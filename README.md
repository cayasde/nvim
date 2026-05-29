# Nvim

[![CI](https://img.shields.io/github/actions/workflow/status/cayasde/nvim/ci.yml?branch=main&label=CI&style=for-the-badge)](https://github.com/cayasde/nvim/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/License-MIT-2ea44f?style=for-the-badge)](./LICENSE)
[![Size](https://img.shields.io/github/repo-size/cayasde/nvim?label=SIZE&logo=codesandbox&style=for-the-badge)](https://github.com/cayasde/nvim)
[![Last Commit](https://img.shields.io/github/last-commit/cayasde/nvim?label=LAST%20COMMIT&style=for-the-badge)](https://github.com/cayasde/nvim/commits/main)

Lua-first Neovim configuration with fast startup, plugin-per-file organization, and a small toolchain built around `mise`, `stylua`, and CI validation.

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

## Commands

```bash
npm run format:lua
npm run format:lua:check
nvim --headless +qa
```

## Performance

- Startup benchmark (`nvim --startuptime`, 5 runs): `17.20 ms` min, `21.47 ms` avg, `30.78 ms` max.
- Plugin count: `28`
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
| [smear-cursor.nvim](https://github.com/sphamba/smear-cursor.nvim) | Cursor trail animation. |
| [tabby.nvim](https://github.com/nanozuki/tabby.nvim) | Custom tabline. |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder for files, buffers, and grep. |
| [tiny-inline-diagnostic.nvim](https://github.com/rachartier/tiny-inline-diagnostic.nvim) | Compact inline diagnostics. |
| [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) | Floating terminal management. |
| [transparent.nvim](https://github.com/xiyaowong/transparent.nvim) | Transparent editor background. |

## License

MIT. See [LICENSE](LICENSE).
