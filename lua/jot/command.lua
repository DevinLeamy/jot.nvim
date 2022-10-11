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

local open_note = function(state)
  print("Open note")
end

local search_files = function(state)
  local notes = util.collect_notes(state.directories)

  for i = 1, #notes do
    print(notes[i].path)
    print(notes[i].file_name)
  end
end

-- Jump to the note under your cursor
local goto_file = function(state)
  local line_text = util.get_line()
  local _, cursor_position = unpack(vim.api.nvim_win_get_cursor(0))

  local jump_note = util.parse_note_jump(state, line_text, cursor_position)
  
  if jump_note == nil then
    return nil
  end

  print(jump_note.path)

  -- Open the note in a new buffer
  Note.open(jump_note)
end


local commands = {
  JotCheck = { func = health_check },
  JotOpenNote = { func = open_note },
  JotList = { func = search_files },
  JotJump = { func = goto_file },
}

-- Register all commands with jot
local register_all = function(state)
  print("Register commands")

  -- Bind the setup state to the commands 
  for command_name, command_config in pairs(commands) do
    local stateful_func = function(args)
      -- Envoke function with state
      command_config.func(state)
    end
    vim.api.nvim_create_user_command(command_name, stateful_func, {})
  end
end

return {
  register_all = register_all
}


