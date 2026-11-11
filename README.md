# Roblox-TS Template

A partially Rojo-managed roblox-ts template.

Includes a GitHub Actions CI/CD pipeline for automated staging and production deployments.

### Technologies

- [Rojo](<https://rojo.space/>) \- Syncs code from your local editor directly into Roblox Studio.
- [Roblox-TS](<https://roblox-ts.com/>) \- Compiles TypeScript into Luau, bringing strict static typing to Roblox development.

### Structure

plaintext

```plaintext
roblox-ts-game/
├── src/
│   ├── client/
│   │   └── main.client.ts      # Client-side entry point
│   ├── server/
│   │   └── main.server.ts      # Server-side entry point
│   └── shared/
│       └── makeHello.ts        # Shared code between client and server
├── default.project.json        # Roblox project configuration
├── eslint.config.ts             # Code linting and formatting rules
├── package.json                 # Project dependencies and scripts
├── pnpm-lock.yaml               # Dependency lockfile
├── rokit.toml                   # Development tools and versions
└── tsconfig.json                # TypeScript configuration
```

## How to use

### Prerequisites

- [PNPM](<https://pnpm.io/>)
- [Rokit](<https://github.com/rojo-rbx/rokit>)

### Setup

**1\. Clone the repository**

bash

```bash
pnpx degit https://github.com/GOFNY/roblox-ts-template
```

**2\. Install development tools**

bash

```bash
rokit install
```

**3\. Sync your project**

bash

```bash
pnpm dev
```

Open Roblox Studio and connect using the Rojo plugin.

And all done\!

## Deploy

Deploys run through GitHub Actions in two stages:

### 1\. Create a release

Run **Actions → Release → Run workflow**.

This workflow:

1. Reads and validates the version from `package.json`.
2. Builds the project and merges the assets place.
3. Generates `deploy.rbxl`.
4. Creates a draft GitHub Release with the generated file attached.

Update the version in `package.json` before creating a release.

### 2\. Publish the release

Once the draft is ready, publish it as either:

- **Pre-release:** Deploys to `staging`.
- **Regular release:** Deploys to `production`.

Publishing the release automatically triggers the deploy workflow, which downloads `deploy.rbxl` and publishes it to the configured Roblox place.

### Configuration

**1\. Repository secret**

Add under **Settings → Secrets and variables → Actions → Repository secrets**:

- `ASSETS_API_KEY`: Open Cloud API key used to download the assets place.

**2\. Repository variable**

Add under **Settings → Secrets and variables → Actions → Repository variables**:

- `ASSETS_PLACE_ID`: Place containing the assets to merge.

**3\. Environments**

Create two environments under **Settings → Environments**:

- `staging`
- `production`

Configure each environment with:

**Secrets:**

- `ROBLOX_API_KEY`: Open Cloud API key used to publish to the environment's Roblox place.

**Variables:**

- `UNIVERSE_ID`: Destination experience's universe ID.
- `PLACE_ID`: Destination place ID.

Use separate Roblox API keys and destination IDs for each environment.

### API key permissions

Create both keys in the [Roblox Creator Hub](<https://create.roblox.com/dashboard/credentials>).

| Secret | Required permission |
| --- | --- |
| `ASSETS_API_KEY` | `legacy-asset:manage` (Asset Delivery) |
| `ROBLOX_API_KEY` | `universe-places:write` (Place Publishing) |

The assets key must have access to the assets place. The publishing key must have Write access to the corresponding destination experience.

## Daily development scripts

- `pnpm lint`: Run ESLint checks.
- `pnpm format`: Run Prettier checks.
- `pnpm compile`: Compile the project.
- `pnpm build`: Build the project.
- `pnpm dev`: Run watch and serve in parallel.

## License

This project is licensed under the [MIT-0 License](./LICENSE).
