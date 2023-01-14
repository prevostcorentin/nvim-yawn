local M = {}

local __throw_error = function(message)
	assert(false, message)
end

function M.get_current_working_directory()
	local current_working_directory = io.popen("pwd"):read("*l")
	return current_working_directory
end

function M.path_exists(disk_path)
	local is_command_successful, _, code = os.rename(disk_path, disk_path)
	local disk_path_exists = false
	if not is_command_successful and code == 13 then
		disk_path_exists = true
	elseif is_command_successful == true then
		disk_path_exists = true
	end
	return disk_path_exists
end

function M.is_directory(disk_path)
	local directory_path = disk_path .. "/"
	local is_directory = M.path_exists(directory_path)
	return is_directory
end

function M.is_file(disk_path)
	local file_descriptor = io.open(disk_path, "rb")
	local is_file = false
	if nil ~= file_descriptor then
		io.close(file_descriptor)
		is_file = true
	end
	return is_file
end

function M.read_all_file(file_path)
	if not M.is_file(file_path) then
		local error_message = file_path + " is not a file"
		__throw_error(error_message)
	end
	local file_descriptor = io.open(file_path, "r")
	---@diagnostic disable-next-line: need-check-nil
	local file_content = file_descriptor:read("*a")
	io.close(file_descriptor)
	return file_content
end

function M.enumerate_directory_files(directory_path)
	if M.is_directory(directory_path) then
		local error_message = directory_path + " is not a directory."
		__throw_error(error_message)
	end
	local command = "find " .. directory_path .. " -depth 1"
	local execution_result = io.popen(command)
	---@diagnostic disable-next-line: need-check-nil
	local files_enumerator = execution_result:lines("a")
	return files_enumerator
end

function M.join_paths(...)
	local joined_paths = {}
	for index, path in ipairs(...) do
		joined_paths[index] = path
	end
	local file_path = table.concat(joined_paths, "/")
	return file_path
end

return M
