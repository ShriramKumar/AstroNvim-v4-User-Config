--if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

-- function for calculating the current session name
local get_session_name = function()
  local name = vim.fn.getcwd()
  local branch = vim.fn.system("git branch --show-current")
  if vim.v.shell_error == 0 then
    return name .. vim.trim(branch --[[@as string]])
  else
    return name
  end
end

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    sessions = {
      -- disable the auto-saving of directory sessions
      autosave = { cwd = false },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      	colorcolumn = "80", --sets vim.opt.colorcolumn
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    autocmds = {
      -- disable alpha autostart
      alpha_autostart = false,
      git_branch_sessions = {
        -- auto save directory sessions on leaving
        {
          event = "VimLeavePre",
          desc = "Save git branch directory sessions on close",
          callback = vim.schedule_wrap(function()
            if require("astrocore.buffer").is_valid_session() then
              require("resession").save(
                get_session_name(),
                { dir = "dirsession", notify = false }
              )
            end
          end),
        },
        -- auto restore previous previous directory session, remove if necessary
        {
          event = "VimEnter",
          desc = "Restore previous directory session if neovim opened with no arguments",
          nested = true, -- trigger other autocommands as buffers open
          callback = function()
            -- Only load the session if nvim was started with no args
            if vim.fn.argc(-1) == 0 then
              -- try to load a directory session using the current working directory
              require("resession").load(
                get_session_name(),
                { dir = "dirsession", silence_errors = true }
              )
            end
          end,
        },
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      v = {},
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

	-- git branch specific session management
        ["<Leader>SS"] = {
          function()
            require("resession").save(
              get_session_name(),
              { dir = "dirsession" }
            )
          end,
          desc = "Save current git branch session",
        },
        -- update load dirsession mapping to get the correct session name
        ["<Leader>S."] = {
          function()
            require("resession").load(
              get_session_name(),
              { dir = "dirsession" }
            )
          end,
          desc = "Load current git branch session",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },
    },
  },
}
