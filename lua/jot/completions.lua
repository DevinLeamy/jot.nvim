local util = require "jot.util"

local source = {}

-- Initializes a new nvim-cmp source, with 
-- a the given state
source.new = function(state)
  source.state = state
  return setmetatable({}, { __index = source })
end

source.get_trigger_characters = function() 
  return { "[" }
end

-- nvim-cmp hook; runs whenever the a trigger character 
-- (defined above) is input.
source.complete = function(self, request, callback)
  -- Retrieves the link that is being typed, as a string. 
  -- Returns nil in no valid link start is found
  -- 
  --
  -- eg: "[[li" for some line "insert [[li"
  --                                  |||| 
  --                 link being typed ^^^^      
  local function get_link_segment(input)
    for i = string.len(input), 1, -1 do
      local substr = string.sub(input, i)
      if vim.endswith(substr, "]") then
        return nil
      elseif vim.startswith(substr, "[[") then
        return substr
      end
    end
    return nil
  end

  local link_segment = get_link_segment(request.context.cursor_before_line)

  if link_segment  == nil or not vim.startswith(link_segment, "[[") then
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

return source
