--- References ---
-- https://github.com/lazyvim/lazyvim
-- https://github.com/nvchad/nvchad
-- https://github.com/astronvim/astronvim
-- https://github.com/nvim-lua/kickstart.nvim
-- https://github.com/ayamir/nvimdots
-- https://github.com/NormalNvim/NormalNvim
-- https://github.com/lunarvim/lunarvim

--- Options ---
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamed,unnamedplus"
vim.opt.cmdheight = 0
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.cursorline = true

--- Keybindings ---
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.keymap.set({ "i", "c" }, "jk", "<Esc>", { desc = "Back to normal mode" })
vim.keymap.set({ "n" }, "j", "gj", { desc = "Go to next line" })
vim.keymap.set({ "n" }, "k", "gk", { desc = "Go to prev line" })
vim.keymap.set({ "n" }, "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set({ "n" }, "<C-j>", "<C-w>j", { desc = "Go to bottom window" })
vim.keymap.set({ "n" }, "<C-k>", "<C-w>k", { desc = "Go to top window" })
vim.keymap.set({ "n" }, "<C-l>", "<C-w>l", { desc = "Go to right window" })
vim.keymap.set({ "i" }, "<C-a>", "<Home>", { desc = "Go to line head" })
vim.keymap.set({ "i" }, "<C-e>", "<End>", { desc = "Go to line end" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

--- AutoCmd --
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("my_highlight_yank", { clear = true }),
	callback = function()
		if vim.fn.has("nvim-0.13") == 1 then
			vim.hl.hl_op()
		else
			(vim.hl or vim.highlight).on_yank({ timeout = 1000 })
		end
	end,
})
vim.api.nvim_create_autocmd("BufReadPost", {
	group = vim.api.nvim_create_augroup("my_goto_last_loc", { clear = true }),
	callback = function(event)
		local exclude = { "gitcommit" }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
			return
		end
		vim.b[buf].lazyvim_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("my_close_with_q", { clear = true }),
	pattern = {
		"PlenaryTestPopup",
		"checkhealth",
		"dap-float",
		"dbout",
		"gitsigns-blame",
		"grug-far",
		"help",
		"lspinfo",
		"neotest-output",
		"neotest-output-panel",
		"neotest-summary",
		"notify",
		"qf",
		"spectre_panel",
		"startuptime",
		"tsplayground",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.schedule(function()
			vim.keymap.set("n", "q", function()
				vim.cmd("close")
				pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
			end, {
				buffer = event.buf,
				silent = true,
				desc = "Quit buffer",
			})
		end)
	end,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = vim.api.nvim_create_augroup("my_fix_json_conceal", { clear = true }),
	pattern = { "json", "jsonc", "json5" },
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = vim.api.nvim_create_augroup("my_auto_create_dir", { clear = true }),
	callback = function(event)
		if event.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("my_disable_auto_comment", { clear = true }),
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
	desc = "Disable automatic comment leader on new line",
})
vim.api.nvim_create_autocmd("VimResized", {
	group = vim.api.nvim_create_augroup("my_resize_splits", { clear = true }),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
	desc = "Auto-resize splits when window is resized",
})
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("my_term_settings", { clear = true }),
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = "no"
		vim.opt_local.spell = false
		vim.cmd("startinsert")
	end,
	desc = "Terminal window settings and auto-insert",
})
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("my_wrap_spell", { clear = true }),
	pattern = { "gitcommit", "markdown", "text", "plaintex" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
	desc = "Enable wrap and spell check for prose",
})
vim.api.nvim_create_autocmd("BufReadPre", {
	group = vim.api.nvim_create_augroup("my_big_file_protect", { clear = true }),
	callback = function(event)
		local max_size = 2 * 1024 * 1024
		local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(event.buf))
		if ok and stats and stats.size > max_size then
			vim.b[event.buf].bigfile = true
			vim.opt_local.swapfile = false
			vim.opt_local.foldmethod = "manual"
			vim.opt_local.undolevels = -1
			vim.cmd("syntax off")
		end
	end,
	desc = "Disable heavy features on large files",
})

--- Packages ---
local profile = vim.env.NVIM_PROFILE or "lazyvim"
vim.g.profile = profile
local data_dir = vim.fn.stdpath("data") .. "/" .. vim.g.profile
local state_dir = vim.fn.stdpath("state") .. "/" .. vim.g.profile
local config_dir = vim.fn.stdpath("config")
local lazyroot = data_dir .. "/lazy"
local lazypath = lazyroot .. "/lazy.nvim"

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

local specs = {}
if vim.g.profile == "lazyvim" then
	specs = {
		{
			"LazyVim/LazyVim",
			opts = { colorscheme = "tokyonight-night" },
		},
		{ import = "lazyvim.plugins" },
		{ import = "lazyvim.plugins.extras.editor.illuminate" },
		{ import = "lazyvim.plugins.extras.editor.neo-tree" },
		{ import = "lazyvim.plugins.extras.editor.navic" },
		{ import = "lazyvim.plugins.extras.editor.overseer" },
		{ import = "lazyvim.plugins.extras.editor.refactoring" },
		{ import = "lazyvim.plugins.extras.lang.json" },
		{ import = "lazyvim.plugins.extras.lang.python" },
		{ import = "lazyvim.plugins.extras.lang.toml" },
		{ import = "lazyvim.plugins.extras.lang.yaml" },
		{ import = "lazyvim.plugins.extras.lsp.none-ls" },
		{ import = "lazyvim.plugins.extras.ui.treesitter-context" },
		{
			"folke/snacks.nvim",
			opts = {
				scroll = {
					enabled = false,
				},
			},
		},
		{
			"saghen/blink.cmp",
			version = "1.*",
			opts = {
				completion = {
					menu = {
						border = "rounded",
						winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
					},
					documentation = {
						window = {
							border = "rounded",
						},
					},
				},
			},
		},
	}
end

if vim.g.profile == "astro" then
	specs = {
		{
			"AstroNvim/AstroNvim",
			version = "^6",
			import = "astronvim.plugins",
		},
		{ "AstroNvim/astrocommunity" },
		{ import = "astrocommunity.bars-and-lines.vim-illuminate" },
		{ import = "astrocommunity.code-runner.overseer-nvim" },
		{ import = "astrocommunity.color.modes-nvim" },
		{ import = "astrocommunity.color.nvim-highlight-colors" },
		{ import = "astrocommunity.diagnostics.trouble-nvim" },
		{ import = "astrocommunity.editing-support.nvim-treesitter-context" },
		{ import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
		{ import = "astrocommunity.editing-support.todo-comments-nvim" },
		{ import = "astrocommunity.indent.snacks-indent-hlchunk" },
		{ import = "astrocommunity.pack.json" },
		{ import = "astrocommunity.pack.python" },
		{ import = "astrocommunity.pack.toml" },
		{ import = "astrocommunity.pack.yaml" },
		{ import = "astrocommunity.programming-language-support.csv-vim" },
	}
end

if vim.g.profile == "nvchad" then
	vim.g.base46_cache = data_dir .. "/base46/"
	specs = {
		{
			"NvChad/NvChad",
			lazy = false,
			branch = "v2.5",
			import = "nvchad.plugins",
			config = function()
				local ok, err = pcall(function()
					dofile(vim.g.base46_cache .. "defaults")
					dofile(vim.g.base46_cache .. "statusline")
				end)
				if not ok then
					vim.notify(err, vim.log.levels.ERROR)
				end
				require("nvchad.options")
				require("nvchad.autocmds")
				vim.schedule(function()
					require("nvchad.mappings")
				end)
			end,
		},
	}
end

if vim.g.profile == "mini" then
	specs = {
		{
			"nvim-mini/mini.nvim",
			version = "*",
			config = function()
				vim.cmd.colorscheme("miniwinter")
				require("mini.basics").setup()
				require("mini.icons").setup({
					style = "glyph",
				})
				require("mini.statusline").setup()
				require("mini.tabline").setup()
				require("mini.indentscope").setup({})
				require("mini.cursorword").setup({
					delay = 200,
				})
				require("mini.files").setup({
					windows = {
						preview = true,
						width_focus = 30,
						width_preview = 50,
					},
				})
				vim.keymap.set("n", "<leader>e", function()
					local MiniFiles = require("mini.files")
					if not MiniFiles.close() then
						MiniFiles.open(vim.api.nvim_buf_get_name(0), true)
					end
				end, { desc = "Open MiniFiles (current file)" })
				vim.keymap.set("n", "<leader>E", function()
					local MiniFiles = require("mini.files")
					if not MiniFiles.close() then
						MiniFiles.open()
					end
				end, { desc = "Open MiniFiles (cwd)" })
				require("mini.pick").setup({
					window = {
						config = function()
							local height = math.floor(0.4 * vim.o.lines)
							local width = math.floor(0.75 * vim.o.columns)
							return {
								anchor = "NW",
								height = height,
								width = width,
								col = math.floor((vim.o.columns - width) / 2),
								row = math.max(0, vim.o.lines - height - vim.o.cmdheight - 2),
								border = "rounded",
							}
						end,
					},
					options = {
						content_from_bottom = true,
					},
				})
				vim.keymap.set("n", "<leader>ff", "<Cmd>Pick files<CR>", { desc = "Find Files" })
				vim.keymap.set("n", "<leader>fb", "<Cmd>Pick buffers<CR>", { desc = "Find Buffers" })
				vim.keymap.set("n", "<leader>fw", "<Cmd>Pick grep_live<CR>", { desc = "Find Words" })
				require("mini.pairs").setup()
				require("mini.clue").setup({
					triggers = {
						{ mode = { "n", "x" }, keys = "<Leader>" },
						{ mode = "n", keys = "[" },
						{ mode = "n", keys = "]" },
						{ mode = "i", keys = "<C-x>" },
						{ mode = { "n", "x" }, keys = "g" },
						{ mode = { "n", "x" }, keys = "'" },
						{ mode = { "n", "x" }, keys = "`" },
						{ mode = { "n", "x" }, keys = '"' },
						{ mode = { "i", "c" }, keys = "<C-r>" },
						{ mode = "n", keys = "<C-w>" },
						{ mode = { "n", "x" }, keys = "z" },
					},
					clues = {
						require("mini.clue").gen_clues.square_brackets(),
						require("mini.clue").gen_clues.builtin_completion(),
						require("mini.clue").gen_clues.g(),
						require("mini.clue").gen_clues.marks(),
						require("mini.clue").gen_clues.registers(),
						require("mini.clue").gen_clues.windows(),
						require("mini.clue").gen_clues.z(),
					},
					window = {
						config = {},
						delay = 300,
						scroll_down = "<C-d>",
						scroll_up = "<C-u>",
					},
				})
			end,
		},
	}
end

if vim.g.profile == "self" then
	specs = {
		{
			"akinsho/bufferline.nvim",
			lazy = true,
			event = "VeryLazy",
			version = "*",
			dependencies = "nvim-tree/nvim-web-devicons",
			config = function()
				require("bufferline").setup({})
			end,
		},
		{
			"nvim-lualine/lualine.nvim",
			lazy = true,
			event = "VeryLazy",
			dependencies = "nvim-tree/nvim-web-devicons",
			config = function()
				require("lualine").setup({
					options = {
						component_separators = { left = "", right = "" },
						section_separators = { left = "", right = "" },
					},
				})
			end,
		},
		{
			"lukas-reineke/indent-blankline.nvim",
			lazy = true,
			event = "VeryLazy",
			main = "ibl",
			config = function()
				require("ibl").setup({
					debounce = 200,
					indent = {
						char = "│",
						tab_char = "│",
						smart_indent_cap = true,
						priority = 1,
					},
					whitespace = { remove_blankline_trail = true },
					scope = {
						enabled = true,
						char = "┃",
						show_start = false,
						show_end = false,
						injected_languages = true,
						priority = 1000,
					},
				})
			end,
		},
		{
			"Bekaboo/dropbar.nvim",
			lazy = true,
			event = "VeryLazy",
			opts = {},
		},
		{
			"rcarriga/nvim-notify",
			lazy = true,
			event = "VeryLazy",
			config = function()
				local notify = require("notify")
				notify.setup({
					stages = "fade",
					render = "default",
					fps = 20,
					timeout = 2000,
					minimum_width = 50,
					background_colour = "NotifyBackground",
				})
				vim.notify = notify
			end,
		},
		{
			"HiPhish/rainbow-delimiters.nvim",
			config = function()
				vim.g.rainbow_delimiters = {
					strategy = {
						[""] = "rainbow-delimiters.strategy.global",
						vim = "rainbow-delimiters.strategy.local",
					},
					query = {
						[""] = "rainbow-delimiters",
						lua = "rainbow-blocks",
					},
					priority = {
						[""] = 110,
						lua = 210,
					},
					highlight = {
						"RainbowDelimiterRed",
						"RainbowDelimiterYellow",
						"RainbowDelimiterBlue",
						"RainbowDelimiterOrange",
						"RainbowDelimiterGreen",
						"RainbowDelimiterViolet",
						"RainbowDelimiterCyan",
					},
				}
			end,
		},
		{
			"lewis6991/gitsigns.nvim",
			lazy = true,
			event = "VeryLazy",
			opts = {},
		},
		{
			"folke/which-key.nvim",
			lazy = true,
			event = "VeryLazy",
			config = function()
				local wk = require("which-key")
				wk.setup({
					preset = "modern",
				})
				wk.add({
					{ "<leader>f", group = "+Find" },
				})
			end,
		},
		{
			"windwp/nvim-autopairs",
			lazy = true,
			event = "InsertEnter",
			opts = {},
		},
		{
			"ibhagwan/fzf-lua",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			opts = {
				winopts = {
					height = 0.88,
					width = 0.92,
					border = "rounded",
				},
			},
			keys = {
				{ "<leader><leader>", "<Cmd>FzfLua commands<CR>", desc = "Find Commands" },
				{ "<leader>ff", "<Cmd>FzfLua files<CR>", desc = "Find Files" },
				{ "<leader>fb", "<Cmd>FzfLua buffers<CR>", desc = "Find Buffers" },
				{ "<leader>fs", "<Cmd>FzfLua blines<CR>", desc = "Find Current Buffer Words" },
				{ "<leader>fc", "<Cmd>FzfLua colorschemes<CR>", desc = "Find Themes" },
				{ "<leader>fr", "<Cmd>FzfLua oldfiles<CR>", desc = "Find Recent Files" },
				{ "<leader>fw", "<Cmd>FzfLua live_grep<CR>", desc = "Find Words" },
			},
		},
		{
			"folke/todo-comments.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
			opts = {},
			keys = {
				{ "<leader>ft", "<Cmd>TodoFzfLua<CR>", desc = "Find Todos" },
			},
		},
		{
			"folke/trouble.nvim",
			opts = {},
			cmd = "Trouble",
			keys = {
				{
					"<leader>xx",
					"<Cmd>Trouble diagnostics toggle<CR>",
					desc = "Diagnostics (Trouble)",
				},
				{
					"<leader>xX",
					"<Cmd>Trouble diagnostics toggle filter.buf=0<CR>",
					desc = "Buffer Diagnostics (Trouble)",
				},
				{
					"<leader>xL",
					"<Cmd>Trouble loclist toggle<CR>",
					desc = "Location List (Trouble)",
				},
			},
		},
		{
			"brenoprata10/nvim-highlight-colors",
			lazy = true,
			event = "VeryLazy",
			opts = {
				render = "virtual",
			},
		},
		{
			"RRethy/vim-illuminate",
			lazy = true,
			event = "VeryLazy",
			config = function()
				require("illuminate").configure({
					providers = {
						"lsp",
						"treesitter",
						"regex",
					},
					delay = 100,
					filetype_overrides = {},
					filetypes_denylist = {
						"dirbuf",
						"dirvish",
						"fugitive",
					},
					filetypes_allowlist = {},
					modes_denylist = {},
					modes_allowlist = {},
					providers_regex_syntax_denylist = {},
					providers_regex_syntax_allowlist = {},
					under_cursor = true,
					large_file_cutoff = 10000,
					large_file_overrides = nil,
					min_count_to_highlight = 1,
					should_enable = function(bufnr)
						return true
					end,
					case_insensitive_regex = false,
					disable_keymaps = false,
				})
			end,
		},
		{
			"nvim-tree/nvim-tree.lua",
			cmd = { "NvimTreeToggle" },
			opts = {},
		},
		{
			"mihovilrak/scroll.nvim",
			opts = {
				minimap = true,
				explorer = true,
			},
		},
		{
			"mason-org/mason-lspconfig.nvim",
			opts = {
				ensure_installed = {
					"basedpyright",
					"clangd",
					"lua_ls",
				},
			},
		},
		{
			"hrsh7th/nvim-cmp",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-cmdline",
				"onsails/lspkind.nvim",
				{
					"L3MON4D3/LuaSnip",
					version = "v2.*",
					dependencies = { "rafamadriz/friendly-snippets" },
				},
				"saadparwaiz1/cmp_luasnip",
			},
			config = function()
				local cmp = require("cmp")
				local luasnip = require("luasnip")
				local lspkind = require("lspkind")
				require("luasnip.loaders.from_vscode").lazy_load()
				cmp.setup({
					snippet = {
						expand = function(args)
							luasnip.lsp_expand(args.body)
						end,
					},
					window = {
						completion = cmp.config.window.bordered({
							border = "rounded",
							winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
						}),
						documentation = cmp.config.window.bordered({
							border = "rounded",
							winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
						}),
					},
					mapping = cmp.mapping.preset.insert({
						["<C-b>"] = cmp.mapping.scroll_docs(-4),
						["<C-f>"] = cmp.mapping.scroll_docs(4),
						["<C-Space>"] = cmp.mapping.complete(),
						["<C-e>"] = cmp.mapping.abort(),
						["<C-n>"] = cmp.mapping.select_next_item(),
						["<C-p>"] = cmp.mapping.select_prev_item(),
						["<CR>"] = cmp.mapping.confirm({ select = false }),
						["<Tab>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_next_item()
							elseif luasnip.expand_or_locally_jumpable() then
								luasnip.expand_or_jump()
							else
								fallback()
							end
						end, { "i", "s" }),
						["<S-Tab>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_prev_item()
							elseif luasnip.locally_jumpable(-1) then
								luasnip.jump(-1)
							else
								fallback()
							end
						end, { "i", "s" }),
					}),
					sources = cmp.config.sources({
						{ name = "nvim_lsp" },
						{ name = "luasnip" },
					}, {
						{ name = "buffer" },
						{ name = "path" },
					}),
					formatting = {
						fields = { "abbr", "kind", "menu" },
						format = lspkind.cmp_format({
							mode = "symbol",
							preset = "codicons",
							maxwidth = 50,
							ellipsis_char = "...",
							menu = {
								nvim_lsp = "[LSP]",
								luasnip = "[SNIP]",
								buffer = "[BUF]",
								path = "[PATH]",
								cmdline = "[CMD]",
							},
						}),
					},
					experimental = {
						ghost_text = false,
					},
				})
				cmp.setup.cmdline({ "/", "?" }, {
					mapping = cmp.mapping.preset.cmdline(),
					window = {
						completion = cmp.config.window.bordered({ border = "rounded" }),
					},
					sources = {
						{ name = "buffer" },
					},
				})
				cmp.setup.cmdline(":", {
					mapping = cmp.mapping.preset.cmdline(),
					window = {
						completion = cmp.config.window.bordered({ border = "rounded" }),
					},
					sources = cmp.config.sources({
						{ name = "path" },
					}, {
						{ name = "cmdline" },
					}),
					matching = { disallow_symbol_nonprefix_matching = false },
				})
			end,
		},
		{
			"j-hui/fidget.nvim",
			opts = {},
		},
		{
			"neovim/nvim-lspconfig",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
			},
			config = function()
				local capabilities = require("cmp_nvim_lsp").default_capabilities()
				vim.lsp.config("*", {
					capabilities = capabilities,
				})
				-- Lua
				vim.lsp.config("lua_ls", {
					settings = {
						Lua = {
							runtime = {
								version = "LuaJIT",
							},
							diagnostics = {
								globals = { "vim" },
								disable = { "different-requires", "undefined-field" },
							},
							workspace = {
								library = {
									vim.fn.expand("$VIMRUNTIME/lua"),
									vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
								},
								checkThirdParty = false,
								maxPreload = 100000,
								preloadFileSize = 10000,
							},
							hint = { enable = true, setType = true },
							format = { enable = false },
							completion = {
								callSnippet = "Replace",
							},
							telemetry = {
								enable = false,
							},
							semantic = { enable = false },
						},
					},
				})

				-- C/C++
				vim.lsp.config("clangd", {
					cmd = {
						"clangd",
						"-j=9",
						"--enable-config",
						"--all-scopes-completion",
						"--background-index",
						"--clang-tidy",
						"--completion-parse=auto",
						"--completion-style=detailed",
						"--function-arg-placeholders",
						"--header-insertion-decorators",
						"--header-insertion=iwyu",
						"--limit-references=1000",
						"--limit-results=300",
						"--pch-storage=memory",
					},
				})

				-- Python
				vim.lsp.config("basedpyright", {
					settings = {
						basedpyright = {
							analysis = {
								typeCheckingMode = "standard",
								autoSearchPaths = true,
								diagnosticMode = "openFilesOnly",
							},
						},
					},
				})

				-- Enable LSP with respect to filetype
				vim.lsp.enable({
					"basedpyright",
					"clangd",
					"lua_ls",
				})
			end,
		},
	}
end

local catppuccin_setup = {
	"catppuccin/nvim",
	lazy = false,
	priority = 1000,
	name = "catppuccin",
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			background = {
				light = "latte",
				dark = "mocha",
			},
			transparent_background = false,
			float = {
				transparent = false,
				solid = false,
			},
			term_colors = false,
			dim_inactive = {
				enabled = false,
				shade = "dark",
				percentage = 0.2,
			},
			no_italic = false,
			no_bold = false,
			no_underline = false,
			styles = {
				comments = { "italic" },
				conditionals = { "bold" },
				loops = { "bold" },
				functions = { "bold" },
				keywords = { "italic" },
				strings = {},
				variables = {},
				numbers = {},
				booleans = { "bold", "italic" },
				properties = {},
				types = {},
				operators = { "bold" },
				miscs = {},
			},
			lsp_styles = {
				virtual_text = {
					errors = { "italic" },
					hints = { "italic" },
					warnings = { "italic" },
					information = { "italic" },
					ok = { "italic" },
				},
				underlines = {
					errors = { "underline" },
					hints = { "underline" },
					warnings = { "underline" },
					information = { "underline" },
					ok = { "underline" },
				},
				inlay_hints = {
					background = true,
				},
			},
			color_overrides = {
				mocha = {
					base = "#11111b",
					mantle = "#11111b",
				},
			},
			custom_highlights = {},
			highlight_overrides = {
				all = function(colors)
					return {
						NormalFloat = { fg = colors.text, bg = colors.mantle },
						FloatBorder = {
							fg = colors.blue,
							bg = colors.mantle,
						},
						CursorLineNr = { fg = "#a6e3a1", bold = true },
						Pmenu = { fg = colors.overlay2, bg = colors.base },
						PmenuBorder = { fg = colors.surface1, bg = colors.base },
						PmenuSel = { bg = colors.green, fg = colors.base },
					}
				end,
			},
			auto_integrations = true,
			integrations = {
				aerial = false,
				alpha = true,
				artio = true,
				barbar = false,
				barbecue = {
					dim_dirname = true,
					bold_basename = true,
					dim_context = false,
					alt_background = false,
				},
				beacon = false,
				blink_cmp = {
					style = "bordered",
				},
				blink_indent = true,
				blink_pairs = true,
				buffon = false,
				coc_nvim = false,
				colorful_winsep = {
					enabled = false,
					color = "red",
				},
				dashboard = true,
				diffview = false,
				dropbar = {
					enabled = false,
					color_mode = false,
				},
				fern = false,
				fidget = true,
				flash = false,
				fzf = true,
				gitgraph = false,
				gitsigns = true,
				grug_far = false,
				harpoon = false,
				headlines = false,
				hop = false,
				indent_blankline = {
					enabled = true,
					scope_color = "lavender",
					colored_indent_levels = false,
				},
				leap = false,
				lightspeed = false,
				lir = {
					enabled = false,
					git_status = false,
				},
				lsp_saga = false,
				markview = false,
				mason = true,
				mini = { enabled = false, indentscope_color = "" },
				neotree = false,
				neogit = false,
				neotest = false,
				noice = false,
				notifier = false,
				cmp = false,
				copilot_vim = false,
				dap = true,
				dap_ui = true,
				navic = {
					enabled = true,
					custom_bg = "NONE",
				},
				notify = true,
				nvim_surround = false,
				nvimtree = true,
				treesitter_context = true,
				ts_rainbow2 = false,
				ts_rainbow = false,
				ufo = false,
				window_picker = false,
				octo = false,
				overseer = false,
				pounce = false,
				rainbow_delimiters = true,
				render_markdown = true,
				snacks = {
					enabled = false,
					indent_scope_color = "",
				},
				symbols_outline = false,
				telekasten = false,
				telescope = {
					enabled = false,
				},
				lsp_trouble = false,
				dadbod_ui = false,
				gitgutter = false,
				illuminate = {
					enabled = true,
					lsp = true,
				},
				sandwich = false,
				signify = false,
				vim_sneak = false,
				vimwiki = false,
				which_key = true,
			},
		})
		vim.cmd.colorsche("catppuccin")
	end,
}
local treesitter_setup = {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	branch = "main",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({
			install_dir = data_dir .. "/site",
		})
		require("nvim-treesitter").install({
			"bash",
			"c",
			"cpp",
			"json",
			"lua",
			"markdown",
			"markdown_inline",
			"python",
			"toml",
			"yaml",
		})
	end,
}
local mason_setup = {
	"mason-org/mason.nvim",
	opts = {
		install_root_dir = data_dir .. "/mason",
		ui = {
			border = "rounded",
			width = 0.92,
			height = 0.92,
		},
	},
}
local extra_plugins = {
	lazyvim = {},
	astro = {},
	nvchad = {},
	mini = {},
	self = {},
	all = {
		catppuccin_setup,
		treesitter_setup,
		mason_setup,
	},
}
vim.list_extend(specs, extra_plugins.all)
vim.list_extend(specs, extra_plugins[vim.g.profile] or {})

require("lazy").setup({
	spec = specs,
	root = lazyroot,
	lockfile = config_dir .. "/lockfiles/" .. profile .. ".json",
	state = state_dir .. "/state.json",
	readme = { root = state_dir .. "/readme" },
	rocks = { root = data_dir .. "/rocks" },
	ui = {
		size = {
			width = 0.92,
			height = 0.92,
		},
		border = "rounded",
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"health",
				"man",
				"matchit",
				"matchparen",
				"netrw",
				"netrwFileHandlers",
				"netrwPlugin",
				"rplugin",
				"shada",
				"spellfile",
				"tarPlugin",
				"tutor",
				"tohtml",
				"zipPlugin",
			},
		},
	},
})
