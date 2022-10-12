local Link = require "jot.link"

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
  -- Find the bounds of the next substring matching the 
  -- pattern: [[<text]]
  local function get_link(text) 
    return text:find("%[%[[^%]]+%]%]")
  end

  local links = {}
  local rest_of_line = line

  -- We continuously remove matching patterns from the start
  -- of the string. The helps track the indices of patterns 
  -- in the initial string
  local start_buffer = 0

  while true do
    local left_bound, right_bound = get_link(rest_of_line)

    if left_bound == nil then
      break
    end

    local link_text = rest_of_line:sub(left_bound + 2, right_bound - 2)
    local link = Link.new(start_buffer + left_bound, start_buffer + right_bound, link_text, link_text) 

    table.insert(links, link)

    rest_of_line = rest_of_line:sub(right_bound)
    start_buffer = right_bound - 1
  end

  return links
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
-- @return jot.Note 
util.parse_note_jump = function(state, text, cursor_pos)
  local function get_link_under_cursor()
    local links_on_line = util.get_links(text)

    for i = 1, #links_on_line do
      local link = links_on_line[i]

      if link.left_bound <= cursor_pos and cursor_pos < link.right_bound then
        return link
      end
    end

    return nil
  end

  local function get_note_with_link(link)
    -- Find the note with the given name
    -- TODO: improve such that we aren't searching 
    -- over all notes
    local notes = util.collect_notes(state.directories)

    for i = 1, #notes do
      local note = notes[i]

      if note.file_name == link.link then
        return note
      end
    end  

    return nil 
  end

  local link_under_cursor = get_link_under_cursor()

  if link_under_cursor == nil then
    -- Do nothing
    return nil
  end

  return get_note_with_link(link_under_cursor)
  
end

-- Get the text on the current line
util.get_line = function()
  local line_number = vim.api.nvim__buf_stats(0).current_lnum
  local text = vim.api.nvim_buf_get_lines(0, line_number - 1, line_number, false)[1]

  return text 
end

return util 
