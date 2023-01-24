local Path = require("plenary.path")

local internal = {
	constants = {
		["MODULE_DIRECTORY"] = ".yawn",
		["MAIN_FILE_NAME"] = "workspace.lua",
	},
}

local M = {}

function M.get(option, default)
	local workspace = M.load()
	local value = workspace
	local is_option_defined = M.defines(option)
	if not is_option_defined then
		if default then
			value = default
		else
			assert(
				false,
				option
					.. " is not defined in "
					.. internal.constants.MODULE_DIRECTORY
					.. "/"
					.. internal.constants.MAIN_FILE_NAME
			)
		end
	elseif is_option_defined then
		for option_part in vim.fn.split(option, "\\.") do
			value = value[option_part]
		end
	end
	return value
end

function M.defines(option)
	local workspace_definition = M.load()
	local is_defining_option = true
	for option_part in vim.fn.split(option, "\\.") do
		workspace_definition = workspace_definition[option_part]
		if nil == workspace_definition then
			is_defining_option = false
			break
		end
	end
	return is_defining_option
end

function M.load()
	local workspace_directory = vim.fn.getcwd()
	local workspace_module_file_path =
		Path.new(workspace_directory, internal.constants.MODULE_DIRECTORY, internal.constants.MAIN_FILE_NAME)
	local require_workspace_module = assert(loadfile(workspace_module_file_path.filename))
	local workspace_module = {}
	if workspace_module_file_path:is_file() then
		workspace_module = require_workspace_module()
	end
	workspace_module.directory = vim.fn.getcwd()
	return workspace_module
end

return M
