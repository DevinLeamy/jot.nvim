local util = {}

-- Merge two arrays together 
util.merge_tables = function(t1, t2)
  local res = {unpack(t1)}

  for i = 1, #t2 do
    res[#t1 + i] = t2[i]
  end

  return res
end

-- Split a string on a separator
util.split = function(s, divider)
  if divider == nil then
    divider = "%s"
  end

  local tokens = {}
  for token in string.gmatch(s, "([^"..divider.."]+)") do
    table.insert(tokens, token)
  end

  return tokens
end

-- List all of the files in the vault
util.collect_files = function(search_directories)
  local scan = require "plenary.scandir"

  local files = {}

  for i = 1, #search_directories do
    local search_directory = search_directories[i]

    local matches = scan.scan_dir(vim.fs.normalize(search_directory), {
      hidden = false,
      add_dirs = false,
      respect_gitignore = true,
      search_pattern = ".*%.md",
    })

    files = util.merge_tables(files, matches)
  end

  return files
end

-- Collect all the notes in a list of directories
--
-- @param directories Array<string>
util.collect_notes = function(directories)
  local files = util.collect_files(directories)

  local Note = require "jot.note"

  local notes = {}
  for i = 1, #files do
    local file_path = files[i]
    table.insert(notes, Note.from_path(file_path))
  end

  return notes
end

-- Finds all of the links embedded in a line of text
--
--@param line string
--@return Array<jot.Link>
util.get_links = function(line)
  print("TODO: get links")
end

-- Find the note link locationed at a given cursor position
-- in the given line of text, or return nil if none is found
--
-- ex: [[<link>]]        -> link 
--     [[<text>|<link>]] -> link
--
-- Note: Assumes names do not contain "[", "]", or "|"
--
-- @param text string
-- @param cursor_pos integer
-- @return string
util.parse_note_jump = function(text, cursor_pos)
  print("TODO: parse note jump") 
end

-- Get the text on the current line
util.get_line = function()
  local line_number = vim.api.nvim__buf_stats(0).current_lnum
  local text = vim.api.nvim_buf_get_lines(0, line_number - 1, line_number, false)[1]

  return text 
end

return util 

