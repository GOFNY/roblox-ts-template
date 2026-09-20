local fs = require('@lune/fs')
local net = require('@lune/net')
local process = require('@lune/process')
local roblox = require('@lune/roblox')
local serde = require('@lune/serde')

local url = "https://apis.roblox.com/asset-delivery-api/v1/assetId/%s"
local buildPath = "temp.rbxl"

local assetsAPIKey = process.env["ASSETS_API_KEY"]
assert(assetsAPIKey, "Missing environment variable: 'ASSETS_API_KEY'")

local assetsPlaceId = process.args[1]
local projectPath = process.args[2]
local outputPath = process.args[3]

assert(assetsPlaceId, "Missing argument #1: assetsPlaceId")
assert(projectPath, "Missing argument #2: projectPath")
assert(outputPath, "Missing argument #3: outputPath")

local compileResult = process.exec("rbxtsc")
assert(compileResult.ok, `[{compileResult.code}]: {compileResult.stderr}`)
print(compileResult.stdout)

local buildResult = process.exec("rojo", { "build", "-o", buildPath })
assert(buildResult.ok, `[{buildResult.code}]: {buildResult.stderr}`)
print(buildResult.stdout)

local buildBinary = fs.readFile(buildPath)
fs.removeFile(buildPath)

local buildPlace = roblox.deserializePlace(buildBinary)

local projectEncoded = fs.readFile(projectPath)
local project = serde.decode("json", projectEncoded)

local locationResponse = net.request({
	url = url:format(assetsPlaceId),
	headers = {
		["x-api-key"] = assetsAPIKey
	}
})
assert(locationResponse.ok, `[{locationResponse.statusCode}]: {locationResponse.statusMessage}`)

local locationBody = serde.decode("json", locationResponse.body) :: { location: string?, errors: { { code: string, message: string } }? }
local errors = locationBody.errors
if errors and #errors > 0 then
	local firstError = errors[1]
	assert(not firstError, `[{firstError.code}]: {firstError.message}`)
end

local location = locationBody.location
assert(location, "Asset delivery returned no location")

local binaryResponse = net.request({ url = location })
assert(binaryResponse.ok, `[{binaryResponse.statusCode}]: {binaryResponse.statusMessage}`)

local assetsPlace = roblox.deserializePlace(binaryResponse.body)

type ProjectNode = { [string]: any }

local function isMetaKey(key: string): boolean
	return string.sub(key, 1, 1) == "$"
end

local function copyChildren(from: roblox.Instance, to: roblox.Instance)
	for _, child in from:GetChildren() do
		local existing = to:FindFirstChild(child.Name)
		if existing then
			existing:Destroy()
		end

		child:Clone().Parent = to
	end
end

local function copyProperties(node: ProjectNode, from: any, to: any)
	local properties = node["$properties"]
	if type(properties) ~= "table" then
		return
	end

	for propertyName in properties do
		local ok, err = pcall(function()
			to[propertyName] = from[propertyName]
		end)
		if not ok then
			print(`Could not copy property '{propertyName}' on '{from.Name}': {err}`)
		end
	end
end

local function mergeNode(node: ProjectNode, buildParent: roblox.Instance, assetsParent: roblox.Instance)
	for name, child in node do
		if isMetaKey(name) or type(child) ~= "table" then
			continue
		end

		local buildInstance = buildParent:FindFirstChild(name)
		if not buildInstance then
			print(`'{name}' is in the project but was not found in the build`)
			continue
		end

		local assetsInstance = assetsParent:FindFirstChild(name)

		if not assetsInstance and assetsParent.ClassName == "DataModel" then
			local dataModel = assetsParent :: roblox.DataModel
			local ok, service = pcall(function()
				return dataModel:GetService(name)
			end)
			if ok then
				assetsInstance = service
			end
		end

		if not assetsInstance then
			buildInstance:Clone().Parent = assetsParent
			continue
		end

		if child["$path"] then
			if buildInstance:IsA("LuaSourceContainer") then
				assetsInstance:Destroy()
				buildInstance:Clone().Parent = assetsParent
				continue
			end

			copyChildren(buildInstance, assetsInstance)
		end

		copyProperties(child, buildInstance, assetsInstance)
		mergeNode(child, buildInstance, assetsInstance)
	end
end

assert(project.tree, "Missing 'tree' in project file")
mergeNode(project.tree, buildPlace, assetsPlace)

local finalPlace = roblox.serializePlace(assetsPlace)
fs.writeFile(outputPath, finalPlace)

print("Deploy place successfully built")