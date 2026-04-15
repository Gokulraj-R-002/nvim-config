# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository

Personal Neovim config. Lua-based, uses lazy.nvim for plugin management. Targets Neovim 0.11+ — some code (`vim.lsp.config`, `vim.diagnostic.jump`) relies on APIs introduced in 0.11.

## Load order

1. `init.lua` sets `<leader>` = space (must be set before lazy loads), then requires `config.options`, `config.keymaps`, `config.lazy` in that order.
2. `lua/config/options.lua` — editor options (was `lua/gokul/set.lua` in the packer era).
3. `lua/config/keymaps.lua` — non-plugin keymaps (plugin keymaps live with their plugin specs).
4. `lua/config/lazy.lua` — bootstraps lazy.nvim (clones on first run) and calls `require("lazy").setup({ spec = { { import = "plugins" } } })`, which picks up every file in `lua/plugins/`.

## Plugin layout

Each file in `lua/plugins/` returns a list of lazy.nvim specs. One concern per file:

- `colorscheme.lua` — tokyonight (loaded with `lazy = false, priority = 1000`)
- `telescope.lua` — telescope + plenary dep; keymaps declared via `keys =` for lazy-loading
- `lualine.lua` — statusline
- `treesitter.lua` — nvim-treesitter + nvim-treesitter-textobjects
- `lsp.lua` — mason, mason-lspconfig, nvim-lspconfig, nvim-cmp (+ LuaSnip, cmp_luasnip, cmp-nvim-lsp)
- `gitsigns.lua` — git hunks in sign column + hunk keymaps
- `autopairs.lua` — auto-close brackets/quotes (treesitter-aware)
- `surround.lua` — `ys`/`cs`/`ds` surround operations
- `todo-comments.lua` — highlight TODO/FIXME/NOTE + `:TodoTelescope`
- `render-markdown.lua` — in-buffer markdown preview (headings, code blocks, tables styled). Normal mode shows rendered, insert/visual shows raw for editing. Toggle: `:RenderMarkdown toggle`

## Common commands

Run inside Neovim:

- `:Lazy` — open lazy.nvim UI (install / update / sync / clean / log)
- `:Lazy sync` — install missing + update + clean in one shot
- `:Mason` — UI to install/remove LSP servers (servers install on-demand; `ensure_installed` is empty by design)
- `:TSUpdate` — update treesitter parsers
- `:checkhealth` — diagnose plugin/runtime issues

First run on a new machine: open nvim. lazy.nvim bootstraps itself (clones into `~/.local/share/nvim/lazy/lazy.nvim`) and installs all plugins automatically. `lazy-lock.json` is created next to `init.lua` and **should be committed** for reproducible installs.

## LSP setup (the subtle part)

Pattern used in `lua/plugins/lsp.lua`:

1. `vim.lsp.config("*", { capabilities = ... })` applies cmp-nvim-lsp capabilities to every server.
2. `vim.lsp.config("<server>", { ... })` merges per-server config (see `lua_ls` setting `vim` as a known global).
3. `mason-lspconfig` 2.x auto-enables every Mason-installed server via `vim.lsp.enable()` — no `handlers` wrapper needed.
4. An `LspAttach` autocmd sets buffer-local keymaps once a client attaches.

To customize a server: call `vim.lsp.config("<server>", {...})` inside the `nvim-lspconfig` config function — it deep-merges over the `"*"` defaults.

## Keymaps

Leader is `<space>`. Full list:

- `<leader>pv` — netrw (`:Ex`)
- Telescope: `<leader>ff` find files, `<leader>fg` live grep, `<leader>fb` buffers, `<leader>fd` diagnostics, `<leader>fh` help, `<leader>ft` TODOs
- LSP (buffer-local, on LspAttach): `K` hover, `gd`/`gD`/`gi`/`go` definition/declaration/implementation/type-definition, `gr` references, `gs` signature, `<F2>` rename, `<F3>` format, `<F4>` code action, `<leader>d` diagnostic float, `]d`/`[d` next/prev diagnostic
- Gitsigns: `]c`/`[c` next/prev hunk, `<leader>h{s,r,p,b}` stage/reset/preview/blame
- Treesitter textobjects: `af`/`if` around/inside function, `ac`/`ic` around/inside class, `]f`/`[f` next/prev function
- Todo: `]t`/`[t` next/prev TODO
- nvim-cmp (insert mode): `<C-n>`/`<C-p>` select, `<C-y>` confirm, `<C-Space>` trigger, `<C-u>`/`<C-d>` scroll docs, `<C-f>`/`<C-b>` luasnip jump fwd/back
- Commenting: native `gc`/`gcc` (built-in since 0.10 — no plugin)
- Surround: `ysiw"` wrap word in quotes, `cs"'` change `"` to `'`, `ds(` delete parens (provided by `nvim-surround`)

## Notable options (`lua/config/options.lua`)

- `clipboard = "unnamedplus"` — yank/paste uses system clipboard
- `exrc = true` — sources project-local `.nvim.lua` / `.exrc` from cwd (only open dirs you trust)
- `colorcolumn = "100"` — ruler at col 100
- Indent: 4-space, expandtab, smartindent
- `NVIM_LOG_LEVEL = "WARN"` is set as a process env var to quiet verbose runtime logs

## Adding a new plugin

Create a new file under `lua/plugins/` returning a spec (or table of specs). `require("lazy").setup({ import = "plugins" })` picks it up on next start. Run `:Lazy sync` to install. No manual list to maintain.
