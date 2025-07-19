vim.scriptencoding = "utf-8"
vim.opt.number = true

-- indent width
vim.opt.shiftwidth = 0
vim.opt.tabstop = 4
vim.softtabstop = -1
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.cindent = true
vim.opt.autoindent = true

-- search
vim.opt.ignorecase = false
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- misc
vim.opt.showmatch = true
vim.opt.matchtime = 1
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest", "full" }
vim.opt.syntax = on
vim.opt.cursorline = true
vim.opt.ambiwidth = double
vim.opt.termguicolors = true
vim.opt.pumheight = 20
vim.opt.signcolumn = "yes"

-- floating LSP messages
vim.keymap.set("n", "gd", function()
	vim.diagnostic.open_float()
end, { desc = "Show diagnostic message" })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

	-- color scheme
	{
		-- "Shatur/neovim-ayu",
		-- "nanotech/jellybeans.vim",
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		init = function()
			-- vim.cmd.colorscheme("ayu")
			vim.cmd.colorscheme("gruvbox")
			vim.cmd.hi("Comment gui=none")
		end,
	},

	-- syntax hilight
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")
			configs.setup({
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},

	-- lualine
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "gruvbox",
					tabline = true,
				},
			})
		end,
	},

	-- lsp
	{
		"neovim/nvim-lspconfig",
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		lazy = false,
	},

	-- auto completion
	{
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",

		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
	},

	-- formatter
	{
		"stevearc/conform.nvim",
		opts = {},
		{
			"nvimtools/none-ls.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
		},

		-- auto pair
		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			config = true,
		},

		-- copilot
		{
			"github/copilot.vim",
			lazy = false,
		},

		-- file explorer
		{
			"nvim-tree/nvim-tree.lua",
			version = "*",
			lazy = false,
			dependencies = {
				"nvim-tree/nvim-web-devicons",
			},
			config = function()
				require("nvim-tree").setup({
					sort = { sorter = "case_sensitive" },
					view = {
						width = 30,
						side = "left",
					},
					filters = {
						dotfiles = true,
					},
				})
			end,
		},

		-- TODO hilighting
		{
			"folke/todo-comments.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
			opts = {
				signs = true,
			},
		},
	},
})

require("mason").setup()
require("mason-lspconfig").setup()

capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.opt.completeopt = "menu,menuone"

local cmp = require("cmp")

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
		["<C-Space>"] = cmp.mapping.complete({}),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "path" },
		{ name = "buffer" },
		-- { name = "cmdline" },
	}, {
		{ name = "buffer" },
	}),
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
	matching = { disallow_symbol_nonprefix_matching = false },
})

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	update_in_insert = true,
	underline = true,
})

local signs = {
	Error = "",
	Warn = "",
	Hint = "󱩎",
	Info = "",
}
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- formatter
require("conform").formatters.clang_format = {
	command = "clang-format",
	args = {
		"--style={BasedOnStyle: google, IndentWidth: 4, ColumnLimit: 80, AlignTrailingComments: true}",
	},
}
require("conform").setup({
	formatters_by_ft = {
		c = { "clang_format" },
		cpp = { "clang_format" },
		--]]
		sh = { "shfmt" },
		lua = { "stylua" },

		python = { "black" },
		javascript = { "biome" },
		typescript = { "biome" },

		vhdl = { "vsg" },

		html = { "prettier" },
		css = { "prettier" },
		json = { "prettier" },
	},
	default_format_opts = {
		lsp_format = false,
	},
	format_on_save = true,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

-- launch file explorer
vim.api.nvim_set_keymap("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
