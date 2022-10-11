local Path = require "plenary.path"

local jot = {}
jot.VERSION = "0.1"

local State = {}

-- Initialize the jot state
function State:new(options)
  local new_state = {}

  new_state.directories = {
    "~/Desktop/test_vault"
  }

  self.__index = self
  return setmetatable(new_state, self)
end

-- Set configuration options
jot.setup = function(options)
  print("Setup jot")

  local state = State:new(options)

  require("jot.command").register_all(state)
end

return jot

--[[
  Example configuration.

  require("jot").setup({
    vault_path=/Users/Devin/.local/obsidian/dl
  })
--]]
