local jot_link = {}

-- Link constructor
--
-- @param left_bound integer | column of the left most character in the link
-- @param right_bound integer | similar ^^ 
-- @param text string | text that is display for the note, in markdown
-- @param link string | link <note.md> or <note> or <alias>
jot_link.new = function(left_bound, right_bound, text, link ) 
  local self = setmetatable({}, { __index = link }) 
  self.left_bound = left_bound
  self.right_bound = right_bound
  self.text = text
  self.link = link 

  return self
end

return jot_link
