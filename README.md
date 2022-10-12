# jot.nvim: Seemless navigation between notes

### Example configuration
```lua
require("jot").setup({
    -- Directories to query for notes
    directories = {
      "~/vaults/daily_notes",
      "/Users/John/project_notes"
    },
    -- Enable completions
    display_completions = true,
})
```

### TODO
- [ ] Make completions lazily load
- [ ] Add support for `[[<text>|<link>]]` notes
- [ ] Include note aliases in searches
- [ ] Include note aliases in completions
- [ ] Add display for backlinks to the current note
- [ ] Add go to next note jump
- [ ] Default to including all directories in `jot` config


