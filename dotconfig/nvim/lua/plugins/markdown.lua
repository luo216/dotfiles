return {

  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = "cd app && yarn install",
    -- 设置preveiew浏览器
    config = function()
      vim.g.mkdp_browser = "surf"
      vim.keymap.set("n", "<leader>mr", "<cmd>MarkdownPreview<cr>", { desc = "Markdown preview" })
      vim.keymap.set("n", "<leader>m", " ", { desc = "markdown" })
    end,
  },

  {
    "mzlogin/vim-markdown-toc",
    ft = "markdown",
    config = function()
      vim.keymap.set("n", "<leader>mg", "<cmd>GenTocGFM<cr>", { desc = "Markdown GenTocGFM" })
    end,
  },

  {
    "dhruvasagar/vim-table-mode",
    ft = "markdown",
    config = function()
      vim.g.table_mode_corner_corner = "|"
      vim.g.table_mode_corner_vertical = "|"
      vim.g.table_mode_vertical_corner = "|"
      vim.g.table_mode_enable_mappings = 0
      vim.g.table_mode_map_prefix = "<Leader>mt"
      vim.keymap.set("n", "<leader>mt", "<cmd>TableModeEnable<cr>", { desc = "Markdown table mode" })
      -- vim.keymap.del("n", "<leader>mm")
    end,
  },

  {
    "img-paste-devs/img-paste.vim",
    ft = { "markdown" },
    config = function()
      vim.keymap.set("n", "<leader>mp", "<cmd>call mdip#MarkdownClipboardImage()<CR>", { desc = "Markdown img-paste" })
    end,
  },
}
