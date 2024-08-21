-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {
        {	"nvim-tree/nvim-web-devicons", lazy = false	},
	{	"ggandor/lightspeed.nvim", lazy = false	},
	{
		"OXY2DEV/markview.nvim",
		lazy = false, -- Recommended
		-- ft = "markdown" -- If you decide to lazy-load anyway
		dependencies = {
			-- You will not need this if you installed the
			-- parsers manually
			-- Or if the parsers are in your $RUNTIMEPATH
			"nvim-treesitter/nvim-treesitter",

			"nvim-tree/nvim-web-devicons",
		},
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"mfussenegger/nvim-dap",
		},
	},
	{
		"andythigpen/nvim-coverage",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("coverage").setup()
		end,
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			{
				"fredrikaverpil/neotest-golang", -- Installation
				dependencies = {
					"leoluz/nvim-dap-go",
				},
			},
			{
				"nvim-neotest/neotest-go",
				dependencies = {
					"leoluz/nvim-dap-go",
				},
			},
		},
		config = function()
			local neotest_ns = vim.api.nvim_create_namespace("neotest")
			vim.diagnostic.config({
				virtual_text = {
					format = function(diagnostic)
				  		local message =
				    			diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
				  		return message
					end,
			      	},
			}, neotest_ns)
			require('dap-go').setup()
			require("neotest").setup({
				adapters = {
					require("neotest-go")({
					      experimental = {
						test_table = true,
					      },
					}),
					--require("neotest-golang")({ -- Specify configuration
					--	go_test_args = {
					--		"-v",
					--		"-race",
					--		"-count=1",
					--		"-parallel=1",
					--		"-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
					--	},
					--}), -- Registration
				},
				discovery = {
					-- Drastically improve performance in ginormous projects by
					-- only AST-parsing the currently opened buffer.
					enabled = false,
					-- Number of workers to parse files concurrently.
					-- A value of 0 automatically assigns number based on CPU.
					-- Set to 1 if experiencing lag.
					concurrent = 1,
				},
				running = {
					-- Run tests concurrently when an adapter provides multiple commands to run.
					concurrent = true,
				},
				summary = {
					-- Enable/disable animation of icons.
					animated = true,
					expand_errors = true,
				},
				output = {
					enabled = true,
					open_on_run = "short",
				},
				status = {
					enabled = true,
					signs = true,
					virtual_text = true,
				},
			})
		end,
		keys = {
			{ "<leader>T", desc = "[T]est" },
			{
				"<leader>Ta",
				function()
					require("neotest").run.attach()
				end,
				desc = "[T]est [a]ttach",
			},
			{
				"<leader>Tf",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "[T]est run [f]ile",
			},
			{
				"<leader>TA",
				function()
					require("neotest").run.run(vim.uv.cwd())
				end,
				desc = "[T]est [A]ll files",
			},
			{
				"<leader>TS",
				function()
					require("neotest").run.run({ suite = true })
				end,
				desc = "[T]est [S]uite",
			},
			{
				"<leader>Tn",
				function()
					require("neotest").run.run()
				end,
				desc = "[T]est [n]earest",
			},
			{
				"<leader>Tl",
				function()
					require("neotest").run.run_last()
				end,
				desc = "[T]est [l]ast",
			},
			{
				"<leader>Ts",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "[T]est [s]ummary",
			},
			{
				"<leader>To",
				function()
					require("neotest").output.open({ enter = true, auto_close = true })
				end,
				desc = "[T]est [o]utput",
			},
			{
				"<leader>TO",
				function()
					require("neotest").output_panel.toggle()
				end,
				desc = "[T]est [O]utput panel",
			},
			{
				"<leader>Tt",
				function()
					require("neotest").run.stop()
				end,
				desc = "[T]est [t]erminate",
			},
			{
				"<leader>Td",
				function()
					require("neotest").run.run({ suite = false, strategy = "dap" })
				end,
				desc = "[d]ebug nearest [T]est",
			},
		},
	},
	{
		"stevearc/conform.nvim",
		lazy = false,
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					go = { "goimports", "gofumpt" },
					md = { "markdownfmt" },
				},
				default_format_opts = {
					lsp_format = "never",
				},
			})
		end,
	},
	{
		"ShriramKumar/lsp-format-modifications.nvim",
		lazy = false,
	},
        {	
		"rmagatti/goto-preview",
		lazy = false,
		config = function()
			require("goto-preview").setup({
				default_mappings = false,
			})
		end,
		keys = {
			{ "<leader>v", desc = "pre[v]iew" },
			{
				"<leader>vd",
				function()
					require("goto-preview").goto_preview_definition({})
				end,
				desc = "[d]efinition",
			},
			{
				"<leader>vt",
				function()
					require("goto-preview").goto_preview_type_definition({})
				end,
				desc = "[t]ype definition",
			},
			{
				"<leader>vi",
				function()
					require("goto-preview").goto_preview_implementation({})
				end,
				desc = "[i]mplementation",
			},
			{
				"<leader>vc",
				function()
					require("goto-preview").close_all_win()
				end,
				desc = "[c]lose all",
			},
			{
				"<leader>vr",
				function()
					require("goto-preview").goto_preview_references()
				end,
				desc = "[r]eferences",
			},
		},
	},
	{
		"klen/nvim-test",
		lazy = false,
		config = function()
			require("nvim-test").setup({
				term = "toggleterm",
				termOpts = {
					direction = "float",
					width = 192,
					height = 48,
				},
			})
		end,
	},
	{
		"ldelossa/gh.nvim",
		lazy = false,
		dependencies = {
			{
				"ldelossa/litee.nvim",
				config = function()
					require("litee.lib").setup()
				end,
			},
		},
		config = function()
			require("litee.gh").setup()
		end,
	},
	{
		"pwntester/octo.nvim",
		lazy = false,
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"ibhagwan/fzf-lua",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("octo").setup()
		end,
	},
	{
		"ruifm/gitlinker.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("gitlinker").setup({
				mappings = "<leader>gy",
				opts = {
					remote = "upstream",
					action_callback = require("gitlinker.actions").copy_to_clipboard,
					print_url = true,
				},
				callbacks = {
					["github.parsec.apple.com"] = require("gitlinker.hosts").get_github_type_url,
				},
			})
		end,
	},
	{ "sainnhe/sonokai", lazy = false },
	{
		"Pocco81/auto-save.nvim",
		lazy = false,
		config = function()
			require("auto-save").setup({
				trigger_events = { "InsertLeave", "TextChanged", "TextChangedI", "TextChangedP", "BufLeave" },
				write_all_buffers = true,
				-- your config goes here
				-- or just leave it empty :)
			})
		end,
	},
	--{ "justinmk/vim-sneak", lazy = false },
	{ "google/vim-jsonnet", lazy = false },

	-- == Examples of Adding Plugins ==

	"andweeb/presence.nvim",
	{
		"ray-x/lsp_signature.nvim",
		event = "BufRead",
		config = function()
			require("lsp_signature").setup()
		end,
	},

	-- == Examples of Overriding Plugins ==

	-- customize alpha options
	{
		"goolord/alpha-nvim",
		opts = function(_, opts)
			-- customize the dashboard header
			opts.section.header.val = {
				" █████  ███████ ████████ ██████   ██████",
				"██   ██ ██         ██    ██   ██ ██    ██",
				"███████ ███████    ██    ██████  ██    ██",
				"██   ██      ██    ██    ██   ██ ██    ██",
				"██   ██ ███████    ██    ██   ██  ██████",
				" ",
				"    ███    ██ ██    ██ ██ ███    ███",
				"    ████   ██ ██    ██ ██ ████  ████",
				"    ██ ██  ██ ██    ██ ██ ██ ████ ██",
				"    ██  ██ ██  ██  ██  ██ ██  ██  ██",
				"    ██   ████   ████   ██ ██      ██",
			}
			return opts
		end,
	},

	-- You can disable default plugins as follows:
	{ "max397574/better-escape.nvim", enabled = true },

	-- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
	{
		"L3MON4D3/LuaSnip",
		config = function(plugin, opts)
			require("astronvim.plugins.configs.luasnip")(plugin, opts) -- include the default astronvim config that calls the setup call
			-- add more custom luasnip configuration such as filetype extend or custom snippets
			local luasnip = require("luasnip")
			luasnip.filetype_extend("javascript", { "javascriptreact" })
		end,
	},

	{
		"windwp/nvim-autopairs",
		config = function(plugin, opts)
			require("astronvim.plugins.configs.nvim-autopairs")(plugin, opts) -- include the default astronvim config that calls the setup call
			-- add more custom autopairs configuration such as custom rules
			local npairs = require("nvim-autopairs")
			local Rule = require("nvim-autopairs.rule")
			local cond = require("nvim-autopairs.conds")
			npairs.add_rules(
				{
					Rule("$", "$", { "tex", "latex" })
						-- don't add a pair if the next character is %
						:with_pair(cond.not_after_regex("%%"))
						-- don't add a pair if  the previous character is xxx
						:with_pair(
							cond.not_before_regex("xxx", 3)
						)
						-- don't move right when repeat character
						:with_move(cond.none())
						-- don't delete if the next character is xx
						:with_del(cond.not_after_regex("xx"))
						-- disable adding a newline when you press <cr>
						:with_cr(cond.none()),
				},
				-- disable for .vim files, but it work for another filetypes
				Rule("a", "a", "-vim")
			)
		end,
	},
}
