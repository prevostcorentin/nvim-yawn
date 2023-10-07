local yawn = {
	workspace = require("yawn.workspace"),
}

local Path = require("plenary.path")

local internal = {
	constants = {
		["DEFAULT_VENV_NAME"] = "venv",
		["ACTIVATE_SCRIPT_PATH"] = "bin/activate",
		["DEFAULT_INTERPRETER"] = "python",
	},
}

local M = {}

function M.has_venv()
	local venv_directory = internal._find_venv_directory()
	local supposed_activate_script_path = Path.new(venv_directory, internal.constants.ACTIVATE_SCRIPT_PATH)
	local has_activate_script_existing = supposed_activate_script_path:is_file()
	return has_activate_script_existing
end

function M.find_venv()
	if not M.has_venv() then
		assert(false, "No virtual environment")
	end
	local venv_directory = internal._find_venv_directory()
	return venv_directory
end

function internal._find_venv_directory()
	local workspace_directory = yawn.workspace.get("directory")
	local venv_name = yawn.workspace.get("python.venv", internal.constants.DEFAULT_VENV_NAME)
	local venv_directory = Path.new(workspace_directory, venv_name, internal.constants.ACTIVATE_SCRIPT_PATH)
	return venv_directory
end

return M
