local Path = require "plenary.path"
local Completions = require "jot.completions"

local jot = {}
jot.VERSION = "0.1"

local State = {}

-- Initialize the jot state
function State:new(options)
  local new_state = {}

  new_state.directories = {
    "~/Desktop/test_vault",
    "/Users/Devin/.local/obsidian/dl/neovim",
  }

  new_state.display_completions = true
  if options.display_completions == false then
    new_state.display_completions = false 
  end

  self.__index = self
  return setmetatable(new_state, self)
end

-- Setup jot completions 
-- TODO: Make this lazyly load when a Markdown buffer 
-- is created
jot.setup_completions = function(state)
  -- nvim_cmp plugin
  local has_cmp, cmp = pcall(require, "cmp")

  -- Does not have cmp or does not want completions
  if not has_cmp or not state.display_completions then
    return
  end

  cmp.register_source('jot', Completions.new(state))


  -- Add cmp_jot.lua to the list of sources
  local sources = {
    { name = "jot" }
  }

  for _, source in pairs(cmp.get_config().sources) do
    if source.name ~= "jot" then
      table.insert(sources, source)
    end
  end

  cmp.setup.buffer { sources = sources }
end

-- Set configuration options
--
-- @param options jot.Config
jot.setup = function(options)
  print("Setup jot")

  local state = State:new(options)

  require("jot.command").register_all(state)

  jot.setup_completions(state)
end

-- jot.Config
-- @field directories Array<string> | absolute path of note directories 
-- @field display_completions boolean | enable completions

return jot

--[[
  Example configuration.

  require("jot").setup({
    vault_path=/Users/Devin/.local/obsidian/dl
  })
--]]
