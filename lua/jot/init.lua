local Path = require "plenary.path"
local FindNoteSource = require "jot.completions.find_note"
local CreateNoteSource = require "jot.completions.create_note"

local jot = {}
jot.VERSION = "0.1"

local State = {}

-- Initialize the jot state
function State:new(options)
  local new_state = {}

  new_state.directories = options.directories or {}
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

  cmp.register_source('jot_find_note', FindNoteSource.new(state))
  cmp.register_source('jot_create_note', CreateNoteSource.new(state))


  -- Add cmp_jot.lua to the list of sources
  -- TODO: simplify this code (just insert/replace "jot" source)
  local sources = {
    { name = "jot_find_note" },
    { name = "jot_create_note" },
  }

  for _, source in pairs(cmp.get_config().sources) do
    if source.name ~= "jot_find_note" and source.name ~= "jot_create_note" then
      table.insert(sources, source)
    end
  end

  cmp.setup.buffer { sources = sources }
end

-- Set configuration options
--
-- @param options jot.Config
--
-- jot.Config
-- @field directories Array<string> | absolute path of note directories 
-- @field display_completions boolean | enable completions
jot.setup = function(options)
  local state = State:new(options)

  require("jot.command").register_all(state)

  jot.setup_completions(state)
end

return jot
