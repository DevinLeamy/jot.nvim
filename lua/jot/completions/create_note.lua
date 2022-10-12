-- nvim-cmp source to provide completion option to create a new note

local util = require "jot.util"
local Completion = require "jot.completions.completion"
local Note = require "jot.note"

local create_note_source = {}

-- Initializes a new nvim-cmp create_note_source with 
-- a the given state
create_note_source.new = function(state)
  create_note_source.state = state
  return setmetatable({}, { __index = create_note_source })
end

create_note_source.get_trigger_characters = function() 
  return { "[" }
end

create_note_source.complete = function(self, request, callback)
  local link_segment = Completion.get_link_segment(request.context.cursor_before_line) 

  if link_segment == nil then
    return callback({})
  end

  local completions = {}

  -- Trim the front "[[" off of the link segment
  local note_name = string.sub(link_segment, 1, #link_segment - 2)

  -- If there does not exist a note with a name matching the 
  -- input text, provide a completion to create it.
  
  table.insert(completions, {
    label = "Create new note: " .. note_name,
    textEdit = {
      newText = "[[" .. note_name .. "]]",
      insert = {
        start = {
          line = request.context.cursor.row - 1,
          -- column of the first "[" in the link
          character = request.context.cursor.col - 1 - #link_segment,
        },
        ['end'] = {
          line = request.context.cursor.row - 1,
          -- column after the last "]" in the link
          character = request.context.cursor.col + 1,
        },
      },
    },
    data = {
      note_name = note_name,
      -- TODO: Add path to the current note (where the new note will be added)
    }
  })

  return callback(completions)
end

-- Create a new note when the completion is executed
create_note_source.execute = function(self, completion_item, callback)
  local data = completion_item.data
  local note_name = data.note_name
  
  Note.create(note_name, "~/Desktop/test_vault")

  return callback
end


return create_note_source
