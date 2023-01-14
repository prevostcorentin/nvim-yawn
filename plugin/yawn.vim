if exists("g:loaded_yawn")
  finish
endif
let g:loaded_yawn = 1

let s:lua_rocks_deps_location = expand("<sfile>:h:r") . "/../lua/yawn/deps"
exe "lua package.path = package.path .. '," . s:lua_rocks_deps_location . "/lua-?/init.lua'" 
