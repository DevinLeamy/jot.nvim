-- nvim-cmp source to provide completions for note names

local util = require "jot.util"
local Completion = require "jot.completions.completion"

local find_note_source = {}

-- Initializes a new nvim-cmp find_note_source with 
-- a the given state
find_note_source.new = function(state)
  find_note_source.state = state
  return setmetatable({}, { __index = find_note_source })
end

find_note_source.get_trigger_characters = function() 
  return { "[" }
end

-- nvim-cmp hook; runs whenever the a trigger character 
-- (defined above) is input.
find_note_source.complete = function(self, request, callback)
  local link_segment = Completion.get_link_segment(request.context.cursor_before_line)

  if link_segment  == nil then 
    return callback({})
  end

  local notes = util.collect_notes(self.state.directories)

  local completions = {}

  for i = 1, #notes do
    local note = notes[i]

    table.insert(completions, {
      label = note.file_name,
      -- Behavior when completion is accepted
      --
      -- Inserts link "[[<link text>]]" and 
      -- places cursor after the link
      textEdit = {
        newText = "[[" .. note.file_name .. "]]",
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
      }
    })
  end


  return callback(completions)
end

return find_note_source 
