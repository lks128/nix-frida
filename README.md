Template for building Frida agent script in TypeScript.

## Usage

```shell
copier copy gh:lks128/nix-frida-agent my-agent
```

## Important points
- entrypoint is `agent/index.ts`
- `nix build` builds a default package `agent` which produces a `result` output containing compiled agent script
- `nix develop` exports the `NODE_PATH` environment variable so that VS Code picks up installed modules
