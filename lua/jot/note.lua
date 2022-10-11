local util = require "jot.util"

-- Jot note 
--
-- @field path string
-- @field file_name string
local note = {}

note.__tostring = function(note) 
  return "File name: " .. note.file_name .. " Path: " .. note.path
end

-- Create a note object from a file path
--
-- @param path string
note.from_path = function(path)
  local self = setmetatable({}, { __index = note })
  self.path = path

  local path_split = util.split(path, "/")

  -- filename.md
  local file_stem = path_split[#path_split]

  -- filename
  local file_name = util.split(file_stem, ".")[1]

  self.file_name = file_name
  
  return self
end

-- Open the given note in a buffer
note.open = function(note)
  -- Save the current note 
  pcall(vim.api.nvim_command, "w!")
  vim.api.nvim_command("e " .. tostring(note.path) .. " | redraw!")
end

return note


