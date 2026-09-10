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

## Scripts

- `pnpm lint`: Run eslint checks.
- `pnpm format`: Run prettier checks.
- `pnpm typecheck`: Run type checks.
- `pnpm compile`: Compile the project.
- `pnpm build`: Build the project (runs compile).
- `pnpm watch`: Start file watch.
- `pnpm serve`: Start rojo watch.
- `pnpm dev`: Runs watch & serve in parallel.

## License

This project is licensed under the MIT license.
