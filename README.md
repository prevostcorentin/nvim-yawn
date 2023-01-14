# nvim-yanw

YANW stands for Yet Another NeoVim Workspace.

This is my own implementation of a directory scoped project workspace. It was designed as a solution for [`nvim-dap`](https://github.com/mfussenegger/nvim-dap) and [`nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig)/[`pyright`](https://github.com/microsoft/pyright) to use project-scoped Python virtual environments rather than system ones.

## Installation

This can not be installed as a plug-in. Put this file in a directory reachable somewhere in neovim `lua` PATH and `require` it. 

## Example

### `python-dap` executable

Lua code
```lua
local do_find_python_executable = function()
  local workspace = require("custom.features.yanw").require()
  local python_executable = "python"
  if workspace.python and workspace.python.executable then
    python_executable = workspace.python.executable
  end
  return python_executable
end

dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch",
    program = do_find_debugee,
    pythonPath = do_find_python_executable,
  },
}

```

`./.nvim/workspace.lua`

```lua
return {
  ["python"] = {
    ["executable"] = "./venv/bin/python3",
  },
}
```

## Configuration

By default, the workspace file should be stored in `[project directory]/.yanw/workspace.lua`. The settings exposed below can be modified.

```lua
local workspace = require("custom.features.yanw")
workspace.module_directory = ".yanw" -- default directory where workspace.lua resides
workspace.main_file_name = "workspace.lua" -- default workspace file name
```
