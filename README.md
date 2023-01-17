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
  on_init = function(client, _)
    if yawn.python.has_venv() then
      client.config.settings.python.pythonPath = yawn.python.find_interpreter()
      client.config.settings.python.venvPath = yawn.python.find_venv()
      client.notify "workspace/didChangeConfiguration"
    end
  end,
  [...]
}
```

## Integrations

### Python

`yawn.python.has_venv()`

Detects whether or not a virtual environment exists in the current directory. If `python.venv.name` is defined, it is assumed that a virtual environment exists. If `python.venv.name` is not defined, a virtual environment will be considered set if it follow the typical structure of a `venv`.

`yawn.python.find_interpreter()`

Find the interpreter whether a virtual environment is defined or not. If a virtual environment is defined **and** `python.interpreter` is defined in `.yawn/workspace.lua` then the virtual environment directory will be suffixed by `python.interpreter`. If no virtual environment is defined, `python.interpreter` will not be joined without any preceding path. `python.interpreter` defaults to "python"

`yawn.python.find_venv()`

Detects whether there is a virtual environment or not in the current working directory. If no virtual environment related options are defined in `.yawn/workspace.lua`, it assumes the following default values:
* `python.interpreter` = "python"
* `python.venv.name` = "venv"

Raises an error if the interpreter executable or the virtual environment folder does not exist.

## Configuration

The workspace file should be stored in `[project directory]/.yawn/workspace.lua`. Those are not modifiable.

## In the foreseeable future

- [ ] NTFS support
