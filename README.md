# nvim-yawn

YAWN stands for Yet Another Workspace for Neovim.

This is my own implementation of a directory scoped project workspace. It was designed as a solution for [`nvim-dap`](https://github.com/mfussenegger/nvim-dap) and [`nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig)/[`pyright`](https://github.com/microsoft/pyright) to use project-scoped Python virtual environments rather than system default version.

## Installation

Install it as a plugin using your favorite package manager.

## Example

### `python-dap` Python executable

Lua code
```lua
local yawn = require("yawn")

dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch",
    program = function()
      return yawn.get("python.debug.debugee", "${file}")
    end,
    pythonPath = function()
      return yawn.get("python.interpreter", "python")
    end
  },
}

```

`./.nvim/workspace.lua`

```lua
return {
  ["python"] = {
    ["interpreter"] = "./venv/bin/python3",
  },
}
```

`dap.configurations.python` will result in:
```lua
{
  [...]
  program = "${file}"
  pythonPath = "./venv/bin/python3"
}
```

### `pyright` with `nvim-lspconfig`

Below configuration will update pyright LSP server configuration to use the virtual environment if it exists.

```lua
local yawn = require "yawn"

lspconfig.pyright.setup {
  on_attach = function(client, bufnr)
    on_configure_client_buffer(client, bufnr)
    if yawn.python.has_venv() then
      client.config.settings.python.pythonPath = yawn.python.find_interpreter()
      client.config.settings.python.venvPath = yawn.python.find_venv()
      client.notify "workspace/didChangeConfiguration"
    end
  end,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "basic",
      },
    },
  },
}
```

## Configuration

The workspace file should be stored in `[project directory]/.yawn/workspace.lua`. Those are not modifiable.

## In the foreseeable future

- [] NTFS support
