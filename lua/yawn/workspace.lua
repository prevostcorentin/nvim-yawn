local filesystem = require("yawn.filesystem")

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
	if M.defines(option) then
		for option_part in internal._split_option(option) do
			value = value[option_part]
		end
	elseif nil ~= default then
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
	return value
end

function M.defines(option)
	local workspace_definition = M.load()
	local is_defining_option = true
	for option_part in internal._split_option(option) do
		workspace_definition = workspace_definition[option_part]
		if nil == workspace_definition then
			is_defining_option = false
			break
		end
	end
	return is_defining_option
end

function internal._split_option(option)
	local splitted_options_iterator = string.gmatch(option, "%a+")
	return splitted_options_iterator
end

function M.load()
	local settings_file_path = internal._build_settings_file_path()
	local local_settings_module = internal._load_settings_file(settings_file_path)
	if nil == local_settings_module then
		local_settings_module = {}
	end
	local_settings_module.directory = filesystem.get_current_working_directory()
	return local_settings_module
end

function internal._build_settings_file_path()
	local current_working_directory = filesystem.get_current_working_directory()
	local module_directory = current_working_directory .. "/" .. internal.constants.MODULE_DIRECTORY
	local settings_file_path = module_directory .. "/" .. internal.constants.MAIN_FILE_NAME
	return settings_file_path
end

function internal._load_settings_file(settings_file_path)
	local settings_module = nil
	if filesystem.is_file(settings_file_path) then
		local settings_module_require = assert(loadfile(settings_file_path))
		settings_module = settings_module_require()
	end
	return settings_module
end

return M
