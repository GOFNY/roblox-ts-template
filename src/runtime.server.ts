import { Flamework } from "@flamework/core";

Flamework.addPathsGlob("src/features/*/shared/**/*Component.ts");
Flamework.addPathsGlob("src/features/*/server/**/*Component.ts");
Flamework.addPathsGlob("src/features/*/server/**/*Service.ts");
Flamework.ignite();

print("Server started");
