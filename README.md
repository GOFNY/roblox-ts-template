# Roblox-TS Template

A Roblox-TS project template integrating Rojo and Flamework (components and networking). 

This template uses a feature-based architecture to separate client, server, and shared code, and includes a pre-configured GitHub Actions CI/CD pipeline for automated staging and production deployments.

### Technologies

- [Rojo](https://rojo.space/) - Syncs code from your local editor directly into Roblox Studio.
- [Roblox-TS](https://roblox-ts.com/) - Compiles TypeScript into Luau, bringing strict static typing to Roblox development.
- [Flamework](https://flamework.fireboltofdeath.dev/) - Provides dependency injection, decorators, and simplified networking for roblox-ts projects.
- [Rogen](https://rogen-playfully.vercel.app/) - Enables feature-based architecture by automatically routing co-located client, server, and shared files to their correct Roblox services.

### Recommended structure

```plaintext
roblox-ts-game
├── src
│   ├── features
│   │   └── example
│   │       ├── client
│   │       │   ├── someClientComponent.ts   
│   │       │   └── someController.ts
│   │       ├── server
│   │       │   ├── someServerComponent.ts
│   │       │   └── someService.ts
│   │       └── shared
│   │       │   ├── someComponent.ts       # Component executed on both the client and the server.
│   │           └── types.ts
│   ├── runtime.client.ts                  # Client entry point.
│   └── runtime.server.ts                  # Server entry point.
├── package.json                           # Package manifest & dependencies.
└── tsconfig.json                          # TypeScript configuration.
```

Use the "nameType" pattern for services, controllers, and components.

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

**3. Compile the project**

```bash
pnpm compile
```

**4. Sync your project**

```bash
pnpm dev
```

Open Roblox Studio and connect using the Rojo plugin.

And all done!

## Deploy

Deploys run through GitHub Actions (`.github/workflows/deploy.yml`):

| Trigger                 | Environment  |
| ----------------------- | ------------ |
| Pre-release published   | `staging`    |
| Release published       | `production` |
| Manual (`Run workflow`) | Your choice  |

### Configuration

**1. Repository secret**

Add it under Settings -> Secrets and variables -> Actions -> Repository secrets:

- `ASSETS_API_KEY`: Open Cloud API key used to download the assets place. Shared by all environments.

**2. Environments**

Create two environments named `staging` and `production` (Settings -> Environments). Each one needs its own values for:

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

## Daily development scripts

- `pnpm lint`: Run eslint checks.
- `pnpm format`: Run prettier checks.
- `pnpm typecheck`: Run type checks.
- `pnpm compile`: Compile the project.
- `pnpm build`: Build the project.
- `pnpm dev`: Runs watch & serve in parallel.

## License

This project is licensed under the [MIT-0 License](/LICENSE)
