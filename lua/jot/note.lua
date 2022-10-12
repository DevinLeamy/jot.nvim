local util = require "jot.util"

-- jot.Note 
--
-- @field path string
-- @field file_name string
local note = {}

-- Constructor
note.new = function(name, path)
  local self = setmetatable({}, { __index = note })
  self.path = path
  self.file_name = name

  return self
end

note.__tostring = function(note) 
  return "File name: " .. note.file_name .. " Path: " .. note.path
end

-- Create a note object from a file path
--
-- @param path string
note.from_path = function(path)
  local path_split = util.split(path, "/")

  -- filename.md
  local file_stem = path_split[#path_split]
  -- filename
  local file_name = util.split(file_stem, ".")[1]
  
  return note.new(file_name, path) 
end

-- Open the given note in a buffer
note.open = function(note)
  -- Save the current note and open the new note
  -- Note: redraw! 
  pcall(vim.api.nvim_command, "w!")
  vim.api.nvim_command("e " .. tostring(note.path) .. " | redraw!")
end

-- Creates and opens a new note. Returns
-- the note that was created
note.create = function(name, path)
  local new_note = note.new(name, path)    
  note.open(new_note)

  return new_note
end

return note


