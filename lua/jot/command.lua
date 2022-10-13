local util = require "jot.util"
local Note = require "jot.note"

-- Search command for notes
-- - ignore configuration files
-- - smart case sensitivity
-- - treat as fixed string, not regex
-- - output as json
-- - search for markdown files
local SEARCH_CMD = "rg --no-config -S -F --json --type md"

local health_check = function(state) 
    print("Jot is healthy")
end

local search_files = function(state)
  local notes = util.collect_notes(state.directories)

  for i = 1, #notes do
    print(notes[i].path)
  end
end

-- Jump to the note under your cursor
--
-- @param state jot.State | (see init.lua)
-- @param data { arg: string | nil } | optional --force argument
local goto_file = function(state, data)
  local argument = data.args
  local force = argument == "--force" or argument == "-f" 

  local line_text = util.get_line()
  local _, cursor_position = unpack(vim.api.nvim_win_get_cursor(0))

  local link_under_cursor = util.parse_note_jump(state, line_text, cursor_position)
  
  if link_under_cursor == nil then
    return
  end 

  local linked_note = util.get_note_with_link(state, link_under_cursor)

  if linked_note == nil and not force then
    return 
  elseif linked_note == nil and force then
    -- Create a note with the given name inside of the current 
    -- directory
    local current_directory = vim.fn.expand('%:h')
    local note_name = link_under_cursor.text

    linked_note = Note.from_dir_and_name(current_directory, note_name)
  end

  print(linked_note.path)

  -- Open the note in a new buffer
  Note.open(linked_note)
end


local commands = {
  JotCheck = { func = health_check, options = { nargs = 0 } },
  JotList = { func = search_files, options = { nargs = 0 } },
  JotJump = { func = goto_file, options = { nargs = "?" } },
}

-- Register all commands with jot
local register_all = function(state)
  -- Bind the setup state to the commands 
  for command_name, command_config in pairs(commands) do
    local stateful_func = function(args)
      -- Envoke function with state
      command_config.func(state, args)
    end
    vim.api.nvim_create_user_command(command_name, stateful_func, command_config.options)
  end
end

return {
  register_all = register_all
}


