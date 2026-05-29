# Nvim

[![CI](https://img.shields.io/github/actions/workflow/status/cayasde/nvim/ci.yml?branch=main&label=CI&style=for-the-badge)](https://github.com/cayasde/nvim/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/License-MIT-2ea44f?style=for-the-badge)](./LICENSE)
[![Size](https://img.shields.io/github/repo-size/cayasde/nvim?label=SIZE&logo=codesandbox&style=for-the-badge)](https://github.com/cayasde/nvim)
[![Last Commit](https://img.shields.io/github/last-commit/cayasde/nvim?label=LAST%20COMMIT&style=for-the-badge)](https://github.com/cayasde/nvim/commits/main)

Neovim configuration with fast startup, plugin-per-file organization, and a small toolchain built around `mise`, `stylua`, and CI validation.

## Tooling

`mise` is the toolchain manager for this repository. It is used to pin and run project tools, currently `stylua`.

## Structure

```text
lua/
  config/    -- bootstrap, editor options, global autocmds
  features/  -- local behavior such as formatting and terminal flows
  keymaps/   -- mappings split by responsibility
  plugins/   -- lazy.nvim plugin specs, one plugin per file
  util/      -- shared helpers
```

## Setup

```bash
mise install
npm ci
```

### Spotify (`smm.nvim`)

This config includes [`iamt4nk/smm.nvim`](https://github.com/iamt4nk/smm.nvim) and reads its credentials from environment variables instead of hardcoding them.

1. Create a Spotify app at <https://developer.spotify.com/dashboard>.
2. Add yourself in the app's `User Management`.
3. Add a redirect URI such as `http://127.0.0.1:8888`.
4. Copy `.env.example` to `.env`.
5. Fill in these variables:

```dotenv
SPOTIFY_CLIENT_ID=your-client-id
SPOTIFY_CALLBACK_URL=http://127.0.0.1
SPOTIFY_CALLBACK_PORT=8888
SPOTIFY_PREMIUM=true
```

This config loads `.env` automatically during startup. Then run `:Spotify` or use `<leader>ms` to start the OAuth flow and open the playback window.

## Commands

```bash
npm run format:lua
npm run format:lua:check
nvim --headless +qa
```

## Keymaps

<details>
<summary>Navigation</summary>

| Key | Mode | Action |
| --- | --- | --- |
| `<Left>` / `<Down>` / `<Up>` / `<Right>` | normal, visual | Use `h`, `gj`, `gk`, `l` style movement. |
| `<Home>` / `<End>` | normal, visual | Jump to first non-blank char or end of line. |
| `<C-Left>` / `<C-Right>` | normal, visual, insert | Move by word. |
| `<C-S-Left>` / `<C-S-Right>` | normal, visual, insert | Select or extend by word. |
| `<C-S-Up>` / `<C-S-Down>` | normal, visual, insert | Select or extend by display line. |

</details>

<details>
<summary>Editing</summary>

| Key | Mode | Action |
| --- | --- | --- |
| `<C-BS>` / `<C-h>` | insert | Delete the previous code chunk, not just a plain word. |
| `<C-w>` | insert | Uses the same code-aware backward delete behavior. |
| `<C-BS>` / `<C-h>` | normal, visual | Delete the previous selection chunk backward. |
| `<BS>` | visual | Delete selection into the black hole register. |

</details>

<details>
<summary>Clipboard And Save</summary>

| Key | Mode | Action |
| --- | --- | --- |
| `<C-x>` | normal, visual | Cut to system clipboard. |
| `<C-c>` | normal, visual | Copy to system clipboard. |
| `<C-v>` | normal, visual | Paste from system clipboard. |
| `<C-z>` / `<C-y>` | normal, visual | Undo / redo. |
| `<C-s>` | normal, visual, insert | Save current buffer. |
| `<C-a>` | normal, insert | Select the entire buffer. |

</details>

<details>
<summary>Window Management</summary>

| Key | Mode | Action |
| --- | --- | --- |
| `<C-q>` | normal | Close current buffer. |
| `<leader>v` / `<leader>h` | normal | Vertical split / horizontal split. |
| `<leader>q` / `<leader>o` | normal | Close current window / keep only current window. |
| `<leader><Left>` / `<leader><Down>` / `<leader><Up>` / `<leader><Right>` | normal | Move across windows. |

</details>

<details>
<summary>UI And Search</summary>

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>e` | normal | Open `oil.nvim` in the current directory. |
| `<leader><leader>` | normal | Find files with Telescope. |
| `<leader>ms` | normal | Open `smm.nvim` / Spotify playback. |
| `<C-p>` | normal | Open recent buffers with Telescope. |
| `<leader>g` | normal | Run live grep with Telescope. |
| `<Esc>` | normal | Clear search highlight and keep escape behavior. |
| `<Esc>` | insert, visual, select, operator-pending | Keep plain escape behavior explicit. |

</details>

<details>
<summary>Terminal</summary>

| Key | Mode | Action |
| --- | --- | --- |
| `<Esc>` | terminal | Leave terminal mode. |
| `<C-\>` / `Ctrl+\`` / `<Nul>` / `<C-Space>` / `<C-@>` | normal, terminal | Toggle the last floating terminal. |
| `<leader>tn` | normal | Create a new floating terminal. |
| `<leader>ts` | normal | Pick an existing terminal from the Telescope selector. |
| `<leader>tk` | normal | Close the last terminal. |

</details>

## Performance

- Startup benchmark (`nvim --startuptime`, 5 runs): `17.20 ms` min, `21.47 ms` avg, `30.78 ms` max.
- Plugin count: `29`
- Loaded during measured session: `21`
- Benchmark logs can be generated locally with:

```bash
nvim --startuptime startup.log +qa
```

## Plugins

| Plugin | Description |
| --- | --- |
| [blink.cmp](https://github.com/Saghen/blink.cmp) | Completion engine. |
| [colorful-winsep.nvim](https://github.com/nvim-zh/colorful-winsep.nvim) | Animated colored window separators. |
| [flash.nvim](https://github.com/folke/flash.nvim) | Fast in-buffer motion and jump UI. |
| [github-nvim-theme](https://github.com/projekt0n/github-nvim-theme) | GitHub-themed colorscheme. |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git hunks in the sign column. |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Indent guides. |
| [lazydev.nvim](https://github.com/folke/lazydev.nvim) | Better Lua dev experience for Neovim config. |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Statusline. |
| [luau-lsp.nvim](https://github.com/lopi-py/luau-lsp.nvim) | Luau and Roblox LSP integration. |
| [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim) | Bridges Mason with `lspconfig`. |
| [mason.nvim](https://github.com/mason-org/mason.nvim) | External tool and LSP installer. |
| [neoscroll.nvim](https://github.com/karb94/neoscroll.nvim) | Smooth scrolling. |
| [noice.nvim](https://github.com/folke/noice.nvim) | Improved command line, messages, and popup UI. |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto-closes brackets and quotes. |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP server configuration. |
| [nvim-notify](https://github.com/rcarriga/nvim-notify) | Better notification UI. |
| [oil.nvim](https://github.com/stevearc/oil.nvim) | File explorer as an editable buffer. |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | Better Markdown rendering. |
| [smm.nvim](https://github.com/iamt4nk/smm.nvim) | Spotify playback manager and controller. |
| [smear-cursor.nvim](https://github.com/sphamba/smear-cursor.nvim) | Cursor trail animation. |
| [tabby.nvim](https://github.com/nanozuki/tabby.nvim) | Custom tabline. |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder for files, buffers, and grep. |
| [tiny-inline-diagnostic.nvim](https://github.com/rachartier/tiny-inline-diagnostic.nvim) | Compact inline diagnostics. |
| [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) | Floating terminal management. |
| [transparent.nvim](https://github.com/xiyaowong/transparent.nvim) | Transparent editor background. |

## License

MIT. See [LICENSE](LICENSE).
