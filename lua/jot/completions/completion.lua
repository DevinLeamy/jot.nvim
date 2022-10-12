-- Utility functions for completions

local completion = {}
-- Retrieves the link that is being typed, as a string. 
-- Returns nil in no valid link start is found
-- 
--
-- eg: "[[li" for some line "insert [[li"
--                                  |||| 
--                 link being typed ^^^^      
completion.get_link_segment = function(input)
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


return completion

