# nvim

![Size](https://img.shields.io/github/repo-size/cayasde/nvim?color=%23DDB6F2&label=SIZE&logo=codesandbox&style=for-the-badge&logoColor=D9E0EE&labelColor=302D41)

Personal Neovim configuration, organized by responsibility and kept intentionally small.

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

## Plugins

| Plugin | Description |
| --- | --- |
| [github-nvim-theme](https://github.com/projekt0n/github-nvim-theme) | GitHub-themed colorscheme. |
| [transparent.nvim](https://github.com/xiyaowong/transparent.nvim) | Transparent editor background. |
| [colorful-winsep.nvim](https://github.com/nvim-zh/colorful-winsep.nvim) | Animated colored window separators. |
| [tiny-inline-diagnostic.nvim](https://github.com/rachartier/tiny-inline-diagnostic.nvim) | Compact inline diagnostics. |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder for files, buffers, and grep. |
| [flash.nvim](https://github.com/folke/flash.nvim) | Fast in-buffer motion and jump UI. |
| [smear-cursor.nvim](https://github.com/sphamba/smear-cursor.nvim) | Cursor trail animation. |
| [neoscroll.nvim](https://github.com/karb94/neoscroll.nvim) | Smooth scrolling. |
| [nvim-notify](https://github.com/rcarriga/nvim-notify) | Better notification UI. |
| [noice.nvim](https://github.com/folke/noice.nvim) | Improved command line, messages, and popup UI. |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Statusline. |
| [blink.cmp](https://github.com/Saghen/blink.cmp) | Completion engine. |
| [lazydev.nvim](https://github.com/folke/lazydev.nvim) | Better Lua dev experience for Neovim config. |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto-closes brackets and quotes. |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Indent guides. |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git hunks in the sign column. |
| [oil.nvim](https://github.com/stevearc/oil.nvim) | File explorer as an editable buffer. |
| [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) | Floating terminal management. |
| [tabby.nvim](https://github.com/nanozuki/tabby.nvim) | Custom tabline. |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | Better Markdown rendering. |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP server configuration. |
| [mason.nvim](https://github.com/mason-org/mason.nvim) | External tool and LSP installer. |
| [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim) | Bridges Mason with `lspconfig`. |
| [luau-lsp.nvim](https://github.com/lopi-py/luau-lsp.nvim) | Luau and Roblox LSP integration. |

## Notes

- `mise` manages the project toolchain.
- `husky` and `lint-staged` run Lua formatting in `pre-commit`.
- GitHub Actions validates formatting and Neovim bootstrap on push and pull request.

## License

MIT. See [LICENSE](LICENSE).
