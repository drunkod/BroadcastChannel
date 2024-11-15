https://github.com/Bojne/telegram_netlify_blog

Let's break down your request and create a Nix flake with three shell scripts (base, build, and runtime) based on the provided Dockerfile commands. We'll translate each Dockerfile stage into a corresponding Nix shell script.

## Nix Flake Structure

Here's the structure we'll aim for:

```
flake.nix
shells/
  base.sh
  build.sh
  runtime.sh
```

## flake.nix

This file will define the Nix flake and its outputs, including the three shell scripts.

```nix
{
  description = "Webapp development environment with shell scripts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    packages.${system} = {
      baseShell = pkgs.writeShellScriptBin "base" ''
        ${self.shells.${system}.base}
      '';
      buildShell = pkgs.writeShellScriptBin "build" ''
        ${self.shells.${system}.build}
      '';
      runtimeShell = pkgs.writeShellScriptBin "runtime" ''
        ${self.shells.${system}.runtime}
      '';
    };

    shells.${system} = {
      base = pkgs.runCommand "base-shell" {} ''
        mkdir -p $out
        cp ${./shells/base.sh} $out/base.sh
        chmod +x $out/base.sh
      '';
      build = pkgs.runCommand "build-shell" {} ''
        mkdir -p $out
        cp ${./shells/build.sh} $out/build.sh
        chmod +x $out/build.sh
      '';
      runtime = pkgs.runCommand "runtime-shell" {} ''
        mkdir -p $out
        cp ${./shells/runtime.sh} $out/runtime.sh
        chmod +x $out/runtime.sh
      '';
    };
  };
}
```

## shells/base.sh

This script corresponds to the `base` stage in the Dockerfile.

```bash
#!/usr/bin/env bash

# Set environment variables
export PNPM_HOME="/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Enable corepack
corepack enable

# Create and navigate to the working directory
mkdir -p /app
cd /app

# Copy package.json and pnpm-lock.yaml (assuming they are in the current directory)
cp package.json pnpm-lock.yaml /app/

echo "Base environment setup complete."
```

## shells/build.sh

This script corresponds to the `build-deps` and `build` stages in the Dockerfile.

```bash
#!/usr/bin/env bash

# Run the base shell script
./base.sh

# Install dependencies
pnpm install --frozen-lockfile

# Copy the project files (assuming they are in the current directory)
cp -r . /app/

# Run the build command
cd /app
export $(cat .env.example)
export DOCKER=true
pnpm run build

echo "Build completed."
```

## shells/runtime.sh

This script corresponds to the `runtime` stage in the Dockerfile.

```bash
#!/usr/bin/env bash

# Run the base shell script
./base.sh

# Copy the built files (assuming they are in /app/dist after running build.sh)
cp -r /app/dist /app/

# Set environment variables for runtime
export HOST=0.0.0.0
export PORT=4321

# Run the application
cd /app/dist/server
node ./entry.mjs
```

## Explanation

* **flake.nix**: Defines the flake and its outputs. It creates three shell scripts (`baseShell`, `buildShell`, `runtimeShell`) by embedding the content of the respective shell scripts from the `shells` directory.
* **shells/base.sh**: Sets up the base environment, including enabling corepack, setting environment variables, and copying `package.json` and `pnpm-lock.yaml`.
* **shells/build.sh**: First runs the `base.sh` script, then installs dependencies using `pnpm install --frozen-lockfile`, copies the project files, and runs the