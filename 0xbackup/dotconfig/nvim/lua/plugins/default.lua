-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
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
        let g:VM_maps["Add Cursor Up"] = 'C-U'
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

	-- override nvim-cmp and add cmp-emoji
	{
		"hrsh7th/nvim-cmp",
		dependencies = { "hrsh7th/cmp-emoji" },
		---@param opts cmp.ConfigSchema
		opts = function(_, opts)
			table.insert(opts.sources, { name = "emoji" })
		end,
	},

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

	-- add more treesitter parsers
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

	-- blink-cmp
	{
		"saghen/blink.cmp",
		dependencies = "rafamadriz/friendly-snippets",
		version = "*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = "none",
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				-- ['<C-e>'] = { 'hide' },
				-- fallback命令将运行下一个非闪烁键盘映射(回车键的默认换行等操作需要)
				["<CR>"] = { "accept", "fallback" }, -- 更改成'select_and_accept'会选择第一项插入
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" }, -- 同时存在补全列表和snippet时，补全列表选择优先级更高

				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },

				["<C-e>"] = { "snippet_forward", "select_next", "fallback" }, -- 同时存在补全列表和snippet时，snippet跳转优先级更高
				["<C-u>"] = { "snippet_backward", "select_prev", "fallback" },
			},
			completion = {
				-- 示例：使用'prefix'对于'foo_|_bar'单词将匹配'foo_'(光标前面的部分),使用'full'将匹配'foo__bar'(整个单词)
				keyword = { range = "full" },
				-- 选择补全项目时显示文档(0.5秒延迟)
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
				-- 不预选第一个项目，选中后自动插入该项目文本
				list = { selection = { preselect = false, auto_insert = true } },
			},
			-- 指定文件类型启用/禁用
			enabled = function()
				return not vim.tbl_contains({
					-- "lua",
					-- "markdown"
				}, vim.bo.filetype) and vim.bo.buftype ~= "prompt" and vim.b.completion ~= false
			end,

			appearance = {
				-- 将后备高亮组设置为 nvim-cmp 的高亮组
				-- 当您的主题不支持blink.cmp 时很有用
				-- 将在未来版本中删除
				use_nvim_cmp_as_default = true,
				-- 将“Nerd Font Mono”设置为“mono”，将“Nerd Font”设置为“normal”
				-- 调整间距以确保图标对齐
				nerd_font_variant = "mono",
			},

			-- 已定义启用的提供程序的默认列表，以便您可以扩展它
			sources = {
				default = { "buffer", "lsp", "path", "snippets" },
				providers = {
					-- score_offset设置优先级数字越大优先级越高
					buffer = { score_offset = 4 },
					path = { score_offset = 3 },
					lsp = { score_offset = 2 },
					snippets = { score_offset = 1 },
				},
			},
		},
		-- 由于“opts_extend”，您的配置中的其他位置无需重新定义它
		opts_extend = { "sources.default" },
	},
}
