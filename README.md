# jot.nvim: Seemless navigation between notes

### Disclaimer
This extension is very much a work in progress. Be wary of breaking updates!

### Installation
Add `https://github.com/DevinLeamy/jot.nvim.git` to [vim-plug](https://github.com/junegunn/vim-plug), [packer](https://github.com/wbthomason/packer.nvim), or any other `nvim` package manager.

```lua
-- ex: packer
require('packer').startup(function(use)
 -- ...
 use 'https://github.com/DevinLeamy/jot.nvim.git'
 -- ...
end)
```

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

### Commands
```bash
:JotJump                  # Jump to the note under your cursor
:JotJump --force (-f)     # Same as :JotJump, but creates the note if it doesn't exist
:JotList                  # List all accessible notes
```

<!--
### TODO
- [ ] Make completions lazily load
- [ ] Add support for `[[<text>|<link>]]` notes
- [ ] Include note aliases in searches
- [ ] Include note aliases in completions
- [ ] Add display for backlinks to the current note
- [ ] Add go to next note jump
- [ ] Default to including all directories in `jot` config

-->
