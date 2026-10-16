local process = require("@lune/process")
local regex = require("@lune/regex")
local stdio = require("@lune/stdio")
local fs = require("@lune/fs")

local validNamePattern = regex.new("^[a-z0-9][a-z0-9._-]{0,213}$")
local defaultName = "roblox-ts-game"

local packageJsonPath = "package.json"
local rogenJsonPath = ".rogen.json"
local licensePath = "LICENSE"
local readmePath = "README.md"
local setupPath = ".lune/setup.luau"

assert(fs.isFile(packageJsonPath), `{packageJsonPath} not found`)
assert(fs.isFile(rogenJsonPath), `{rogenJsonPath} not found`)

local function askProjectName(): string
	while true do
		local input = stdio.prompt("text", `project name (empty for '{defaultName}'): `)
		if input == "" then
			return defaultName
		end
		if validNamePattern:isMatch(input) then
			return input
		end
		stdio.write(stdio.color("red"))
		print("invalid project name: use lower-case letters, numbers, '.', '_' or '-', starting with a letter or number (max 214 characters)")
		stdio.write(stdio.color("reset"))
	end
end

local function replaceName(content: string, newName: string, startAt: number): string
	local head = string.sub(content, 1, startAt - 1)
	local tail = string.sub(content, startAt)

	tail = string.gsub(tail, '("name"%s*:%s*)"[^"]*"', function(prefix)
		return `{prefix}"{newName}"`
	end, 1)

	return head .. tail
end

local function removeIfExists(path: string)
	if fs.isFile(path) then
		fs.removeFile(path)
	end
end

local function run(description: string?, program: string, args: { string })
	if description then
		print(`{description}...`)
	end
	local result = process.exec(program, args, { stdio = "inherit" })
	assert(result.ok, `{program} {table.concat(args, " ")} failed with code {result.code}`)
end

local projectName = askProjectName()

local packageJson = fs.readFile(packageJsonPath)
local rogenJson = fs.readFile(rogenJsonPath)

local projectStart = string.find(rogenJson, '"project"', 1, true)
assert(projectStart, `"project" not found in {rogenJsonPath}`)

fs.writeFile(packageJsonPath, replaceName(packageJson, projectName, 1))
fs.writeFile(rogenJsonPath, replaceName(rogenJson, projectName, projectStart))

removeIfExists(licensePath)
removeIfExists(readmePath)

run("Compiling the project", "pnpm", { "compile" })

print("Done. Byeeeee :)")
fs.removeFile(setupPath)
