package = "kong-plugin-kong-logger"  
version = "0.1.1-1"       

-- Here we extract it from the package name.
local pluginName = package:match("^kong%-plugin%-(.+)$")  -- "-logger"

supported_platforms = {"linux", "macosx"}
source = {
  url = "https://github.com/ysa23/kong-logger.git",
  tag = "0.1.0"
}

description = {
  summary = "Write request and response as logs, including body",
  homepage = "https://www.house-of-code.com",
  license = "MIT"
}

dependencies = {
}

build = {
  type = "builtin",
  modules = {
    -- TODO: add any additional files that the plugin consists of
    ["kong.plugins."..pluginName..".handler"] = "plugins/"..pluginName.."/handler.lua",
    ["kong.plugins."..pluginName..".schema"] = "plugins/"..pluginName.."/schema.lua",
  }
}
