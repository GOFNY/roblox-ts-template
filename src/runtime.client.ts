import { Flamework } from "@flamework/core";

Flamework.addPathsGlob("src/features/*/shared/**/*Component.ts");
Flamework.addPathsGlob("src/features/*/client/**/*Component.ts");
Flamework.addPathsGlob("src/features/*/client/**/*Controller.ts");
Flamework.ignite();

print("Client started");
