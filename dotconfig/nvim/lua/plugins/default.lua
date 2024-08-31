return {
	-- add gruvbox
	{ "ellisonleao/gruvbox.nvim" },

	-- Configure LazyVim to load gruvbox
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "gruvbox",
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
			vim.keymap.set("i", "<C-j>", function()
				return vim.fn["codeium#Accept"]()
			end, { expr = true })
			vim.keymap.set("i", "<C-l>", function()
				return vim.fn["codeium#CycleCompletions"](1)
			end, { expr = true })
			vim.keymap.set("i", "<C-h>", function()
				return vim.fn["codeium#CycleCompletions"](-1)
			end, { expr = true })
			vim.keymap.set("i", "<C-c>", function()
				return vim.fn["codeium#Clear"]()
			end, { expr = true })
		end,
	},

	-- translate
	{
		"voldikss/vim-translator",
		config = function()
			vim.keymap.set("n", "<leader>t", " ", { desc = "translate" })
			vim.keymap.set("n", "<leader>tn", "<cmd>Translate<CR>", { desc = "translate to cmdline" })
			vim.keymap.set("n", "<leader>tw", "<cmd>TranslateW<CR>", { desc = "translate to Window" })
			vim.keymap.set("n", "<leader>tr", "<cmd>TranslateR<CR>", { desc = "translate to Replace" })
			vim.keymap.set("n", "<leader>tc", "<cmd>TranslateX<CR>", { desc = "translate to clipboard" })

			vim.keymap.set("v", "<leader>t", " ", { desc = "translate" })
			vim.keymap.set("v", "<leader>tn", ":'<,'>Translate<CR>", { desc = "translate to cmdline" })
			vim.keymap.set("v", "<leader>tw", ":'<,'>TranslateW<CR>", { desc = "translate to Window" })
			vim.keymap.set("v", "<leader>tr", ":'<,'>TranslateR<CR>", { desc = "translate to Replace" })
			vim.keymap.set("v", "<leader>tc", ":'<,'>TranslateX<CR>", { desc = "translate to clipboard" })

			--Create a function to switch languages
			local function toggleLanguage()
				-- If g:translator target lang is zh, switch to en
				if vim.g.translator_target_lang == "zh" then
					vim.g.translator_target_lang = "en"
					-- Use cmdline to prompt lang to switch to en
					print("translator target lang EN")
				else
					vim.g.translator_target_lang = "zh"
					-- Use cmdline to prompt lang to switch to zh
					print("translator target lang ZH")
				end
			end

			vim.keymap.set("n", "<leader>t<Tab>", toggleLanguage, { desc = "toggle Language" })
		end,
	},

	-- add code rain
	{
		"Eandrju/cellular-automaton.nvim",
		config = function()
			vim.keymap.set("n", "<leader>r", "<cmd>CellularAutomaton make_it_rain<CR>", { desc = "code rain" })
		end,
	},

	-- add color show
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},

	-- add visual-multi
	{
		"mg979/vim-visual-multi",
		init = function()
			vim.cmd([[
        let g:VM_maps = {}
        let g:VM_maps["Add Cursor Down"] = '<C-u>'
        let g:VM_maps["Add Cursor Up"] = ''
      ]])
		end,
	},

	-- add yazi plugin
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

	-- change trouble config
	{
		"folke/trouble.nvim",
		-- opts will be merged with the parent spec
		opts = { use_diagnostic_signs = true },
	},

	-- disable trouble
	{ "folke/trouble.nvim", enabled = true },

	-- add symbols-outline
	{
		"simrat39/symbols-outline.nvim",
		cmd = "SymbolsOutline",
		keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
		config = true,
	},

	-- plenary is telescope necessary dependency
	{ "nvim-lua/plenary.nvim" },

	-- change some telescope options and a keymap to browse plugin files
	{
		"nvim-telescope/telescope.nvim",
		keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
		},
		-- change some options
		opts = {
			defaults = {
				layout_strategy = "horizontal",
				layout_config = { prompt_position = "top" },
				sorting_strategy = "ascending",
				winblend = 0,
			},
		},
	},

	-- add telescope-fzf-native
	{
		"telescope.nvim",
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			config = function()
				require("telescope").load_extension("fzf")
			end,
		},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			-- add tsx and treesitter
			vim.list_extend(opts.ensure_installed, {
				"php",
				"go",
				"c",
				"rust",
				"javascript",
			})
		end,
	},

	-- topbar
	{ "Bekaboo/dropbar.nvim" },

	{
		"Saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		config = true,
	},

	-- the opts function can also be used to change the default opts:
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = function(_, opts)
			table.insert(opts.sections.lualine_x, "😄")
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

	-- add any tools you want to have installed below
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"stylua",
				"shellcheck",
				"shfmt",
				"flake8",
			},
		},
	},

	-- Use <tab> for completion and snippets (supertab)
	-- first: disable default <tab> and <s-tab> behavior in LuaSnip
	{
		"L3MON4D3/LuaSnip",
		keys = function()
			return {}
		end,
	},
	-- then: setup supertab in cmp
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-emoji",
		},
		---@param opts cmp.ConfigSchema
		opts = function(_, opts)
			local has_words_before = function()
				unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			local luasnip = require("luasnip")
			local cmp = require("cmp")

			opts.mapping = vim.tbl_extend("force", opts.mapping, {
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
					-- this way you will only jump inside the snippet region
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					elseif has_words_before() then
						cmp.complete()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			})
		end,
	},
}
