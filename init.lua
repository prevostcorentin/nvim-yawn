local this = {
  ["module_directory"] = ".yawn",
  ["main_file_name"] = "workspace.lua",
}

local __file_exists = function(file_path)
  local file = io.open(file_path, "r")
  if nil ~= file then
    io.close(file)
    return true
  else
    return false
  end
end

local __get_current_working_directory = function()
  local current_working_directory = io.popen("pwd"):read "*l"
  return current_working_directory
end

local __build_settings_file_path = function()
  local current_working_directory = __get_current_working_directory()
  local module_directory = current_working_directory .. "/" .. this.module_directory
  local settings_file_path = module_directory .. "/" .. this.main_file_name
  return settings_file_path
end

local __load_settings_file = function(settings_file_path)
  local settings_module = nil
  if __file_exists(settings_file_path) then
    local settings_module_require = assert(loadfile(settings_file_path))
    settings_module = settings_module_require()
  end
  return settings_module
end

this.require = function()
  local settings_file_path = __build_settings_file_path()
  local local_settings_module = __load_settings_file(settings_file_path)
  if nil == local_settings_module then
    local_settings_module = {}
  end
  local_settings_module.directory = __get_current_working_directory()
  return local_settings_module
end

return this
