-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  -- disable mason for NixOS
  {
    "mason-org/mason.nvim",
    enabled = false,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    enabled = false,
  },
  -- theme
  { "ellisonleao/gruvbox.nvim" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },

  -- multi-cursor
  {
    "mg979/vim-visual-multi",
    init = function()
      vim.cmd([[
        let g:VM_maps = {}
        let g:VM_maps["Add Cursor Down"] = '<C-u>'
        let g:VM_maps["Add Cursor Up"] = 'C-U'
      ]])
    end,
  },

  -- yazi
  {
    "DreamMaoMao/yazi.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>y", "<cmd>Yazi<CR>", desc = "Toggle Yazi" },
    },
  },

  -- diagnostics
  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
  },

  -- search
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },

  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
    },
  },

  -- topbar
  { "Bekaboo/dropbar.nvim" },

  -- statusline
  { "nvim-lualine/lualine.nvim", event = "VeryLazy" },

  -- blink.cmp completion
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "none",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<C-e>"] = { "cancel", "fallback" },
        ["<C-k>"] = { "show", "show_documentation", "hide_documentation" },
      },
    },
  },

  -- ai code codeium
  {
    "Exafunction/codeium.vim",
    event = "BufEnter",
    config = function()
      -- disabled by setting codeium's default keymap
      vim.g.codeium_disable_bindings = 1
      -- change codeium's default keymap
      vim.keymap.set("i", "<C-n>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true })
      vim.keymap.set("i", "<C-j>", function()
        return vim.fn["codeium#CycleCompletions"](1)
      end, { expr = true })
      vim.keymap.set("i", "<C-h>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end, { expr = true })
      vim.keymap.set("i", "<C-l>", function()
        return vim.fn["codeium#Clear"]()
      end, { expr = true })
    end,
  },

  -- or you can return new options to override all the defaults
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      -- add icons for codeium
      local codeiumicons = {
        on = " ",
        off = " ",
        noprompt = " ",
        loading = " ",
      }
      --Create a method to get the icon
      local get_codeium_status_icon = function()
        local codeium_status = vim.fn["codeium#GetStatusString"]()
        if codeium_status == " ON" then
          return codeiumicons.on
        elseif codeium_status == "OFF" then
          return codeiumicons.off
        elseif codeium_status == " * " then
          return codeiumicons.loading
        elseif codeium_status == " 0 " then
          return codeiumicons.noprompt
        else
          return codeium_status
        end
      end

      -- local Util = require("lazyvim.util")
      return {
        sections = {
          lualine_x = {
            { get_codeium_status_icon, separator = "", padding = { left = 0, right = 0 } },
            { "encoding", separator = "", padding = { left = 0, right = 0 } },
            -- { "filetype", separator = "", padding = { left = 0, right = 0 } },
          },
        },
      }
    end,
  },

  -- markdown preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    keys = {
      { "<leader>mr", "<cmd>MarkdownPreviewToggle<CR>", desc = "Markdown Preview", ft = "markdown" },
    },
  },

  -- add color show
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
}
