local yawn = {
	workspace = require("yawn.workspace"),
	filesystem = require("yawn.filesystem"),
}

local internal = {
	constants = {
		["DEFAULT_VENV_NAME"] = "venv",
		["ACTIVATE_SCRIPT_PATH"] = "bin/activate",
		["DEFAULT_INTERPRETER"] = "python",
	},
}

local M = {}

function M.has_venv()
	local has_venv = internal._has_user_venv()
	if has_venv then
		return has_venv
	end
	has_venv = internal._has_default_venv()
	return has_venv
end

function M.find_interpreter()
	local interpreter = nil
	local is_user_venv = internal._has_user_venv()
	local is_default_venv = internal._has_default_venv()
	if is_user_venv then
		interpreter = internal._find_user_venv_interpreter()
	elseif is_default_venv then
		interpreter = internal._find_default_venv_interpreter()
	else
		interpreter = internal._find_system_interpreter()
	end
	return interpreter
end

function M.find_venv()
	local is_user_venv = internal._has_user_venv()
	local is_default_venv = internal._has_default_venv()
	local venv_name = nil
	if is_user_venv then
		venv_name = yawn.workspace.get("python.venv.name")
	elseif is_default_venv then
		venv_name = internal.constants.DEFAULT_VENV_NAME
	else
		assert(false, "No virtual environment defined")
	end
	local venv_directory = yawn.filesystem.join_paths({ yawn.workspace.get("directory"), venv_name })
	return venv_directory
end

function internal._has_user_venv()
	local has_user_defined_venv = yawn.workspace.defines("python.venv")
	return has_user_defined_venv
end

function internal._has_default_venv()
	local default_venv_directory = yawn.filesystem.join_paths({ yawn.workspace.get("directory"), "venv" })
	local activate_script_path =
		yawn.filesystem.join_paths({ default_venv_directory, internal.constants.ACTIVATE_SCRIPT_PATH })
	local is_existing_directory = yawn.filesystem.is_directory(default_venv_directory)
	local has_activate_script = yawn.filesystem.is_file(activate_script_path)
	local has_default_venv = false
	if is_existing_directory and has_activate_script then
		has_default_venv = true
	end
	return has_default_venv
end

function internal._find_user_venv_interpreter()
	local interpreter_name = yawn.workspace.get("python.interpreter", "python")
	local interpreter_path = yawn.filesystem.join_paths({
		yawn.workspace.get("directory"),
		yawn.workspace.get("python.venv.name"),
		"bin",
		interpreter_name,
	})
	return interpreter_path
end

function internal._find_default_venv_interpreter()
	local interpreter_name = yawn.workspace.get("python.interpreter", "python")
	local default_venv_interpreter_path = yawn.filesystem.join_paths({
		yawn.workspace.get("directory"),
		internal.constants.DEFAULT_VENV_NAME,
		"bin",
		interpreter_name,
	})
	local is_existing_interpreter = yawn.filesystem.is_file(default_venv_interpreter_path)
	if not is_existing_interpreter then
		assert(false, default_venv_interpreter_path .. " is not a Python interpreter")
	end
	return default_venv_interpreter_path
end

function internal._find_system_interpreter()
	local interpreter = yawn.workspace.get("python.interpreter", "python")
	return interpreter
end

return M
