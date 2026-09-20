# Roblox-TS Template

A Roblox-TS project template partially Rojo managed with Flamework and Flamework components / networking.

### Technologies

- [Rojo](https://rojo.space/)
- [Roblox-TS](https://roblox-ts.com/)
- [Flamework](https://flamework.fireboltofdeath.dev/)

## How to use

### Prerequisites

- [PNPM](https://pnpm.io/)
- [Rokit](https://github.com/rojo-rbx/rokit)

### Setup

**1. Clone the repository**

```bash
pnpx degit https://github.com/GOFNY/roblox-ts-template
```

**2. Install dependencies**

```bash
rokit install
pnpm install
```

**3. Build the project**

```bash
pnpm build
```

**4. Sync your project**

```bash
pnpm dev
```

Open Roblox Studio and connect using the Rojo plugin.

And all done!

## Deploy

Deploys run through GitHub Actions (`.github/workflows/deploy.yml`):

| Trigger                 | Environment   |
| ----------------------- | ------------- |
| Push to `main`          | `development` |
| Pre-release published   | `staging`     |
| Release published       | `production`  |
| Manual (`Run workflow`) | Your choice   |

### Configuration

**1. Repository secret**

Add it under Settings -> Secrets and variables -> Actions -> Repository secrets:

- `ASSETS_API_KEY`: Open Cloud API key used to download the assets place. Shared by all environments.

**2. Environments**

Create three environments named `development`, `staging` and `production` (Settings -> Environments). Each one needs its own values for:

Secrets:

- `ROBLOX_API_KEY`: Open Cloud API key used to publish to that environment's place.

Variables:

- `ASSETS_PLACE_ID`: Place that holds the assets to be merged with the code.
- `UNIVERSE_ID`: Universe of the place being published.
- `PLACE_ID`: Place that receives the deploy.

Only the values change between environments; the workflow is the same.

### API key permissions

Create both keys in the [Creator Hub](https://create.roblox.com/dashboard/credentials).

| Secret           | Required permission                        | Notes                                                                                                                                      |
| ---------------- | ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------ |
| `ASSETS_API_KEY` | `legacy-asset:manage` (Asset Delivery)     | Create it with an account that owns or can edit the assets place.                                                                          |
| `ROBLOX_API_KEY` | `universe-places:write` (Place Publishing) | Add only the experience of that environment, with the Write operation. Create it under the experience's owner (your account or the group). |

### Running locally

```bash
ASSETS_API_KEY=<key> pnpm run deploy <assetsPlaceId> default.project.json deploy.rbxl
```

## Scripts

- `pnpm lint`: Run eslint checks.
- `pnpm format`: Run prettier checks.
- `pnpm typecheck`: Run type checks.
- `pnpm compile`: Compile the project.
- `pnpm build`: Build the project (runs compile).
- `pnpm watch`: Start file watch.
- `pnpm serve`: Start rojo watch.
- `pnpm dev`: Runs watch & serve in parallel.
- `pnpm run deploy <assetsPlaceId> <project> <output>`: Merge the Rojo build into the assets place (requires `ASSETS_API_KEY`).

## License

This project is licensed under the MIT license.
