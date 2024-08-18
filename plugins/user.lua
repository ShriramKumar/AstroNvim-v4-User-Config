-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {
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
    "stevearc/conform.nvim",
    lazy = false,
    config = function()
      require("conform").setup {
        formatters_by_ft = {
          lua = { "stylua" },
          go = { "goimports", "gofumpt" },
          md = { "markdownfmt" },
        },
        default_format_opts = {
          lsp_format = "never",
        },
      }
    end,
  },
  {
    "ShriramKumar/lsp-format-modifications.nvim",
    lazy = false,
  },
  {
    "olimorris/persisted.nvim",
    lazy = false,
    config = function()
      require("persisted").setup {
        use_git_branch = true,
      }
    end,
  },
  {
    "rmagatti/goto-preview",
    lazy = false,
    config = function()
      require("goto-preview").setup {
        default_mappings = false,
      }
    end,
  },
  {
    "klen/nvim-test",
    lazy = false,
    config = function()
      require("nvim-test").setup {
        term = "toggleterm",
        termOpts = {
          direction = "float",
          width = 192,
          height = 48,
        },
      }
    end,
  },
  {
    "ldelossa/gh.nvim",
    lazy = false,
    dependencies = {
      {
        "ldelossa/litee.nvim",
        config = function() require("litee.lib").setup() end,
      },
    },
    config = function() require("litee.gh").setup() end,
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
    config = function() require("octo").setup() end,
  },
  {
    "ruifm/gitlinker.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("gitlinker").setup {
        mappings = nil,
        opts = {
          remote = "upstream",
        },
        callbacks = {
          ["github.parsec.apple.com"] = require("gitlinker.hosts").get_github_type_url,
        },
      }
    end,
  },
  { "sainnhe/sonokai", lazy = false },
  {
    "Pocco81/auto-save.nvim",
    lazy = false,
    config = function()
      require("auto-save").setup {
        trigger_events = { "InsertLeave", "TextChanged", "TextChangedI", "TextChangedP", "BufLeave" },
        write_all_buffers = true,
        -- your config goes here
        -- or just leave it empty :)
      }
    end,
  },
  { "justinmk/vim-sneak", lazy = false },
  { "google/vim-jsonnet", lazy = false },

  -- == Examples of Adding Plugins ==

  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
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
  { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
}
