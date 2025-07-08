return {
  "AstroNvim/astrolsp",
  -- we need to use the function notation to get access to the `lspconfig` module
  ---@param opts AstroLSPOpts
  opts = function(plugin, opts)
    -- insert "gopls" into our list of servers
    opts.servers = opts.servers or {}
    table.insert(opts.servers, "gopls")

    -- extend our configuration table to have our new prolog server
    opts.config = require("astrocore").extend_tbl(opts.config or {}, {
      -- this must be a function to get access to the `lspconfig` module
      gopls = {
        -- the command for starting the server
        cmd = {
          "gopls",
          "-remote",
          ":37374",
        },
        -- the filetypes to attach the server to
        filetypes = { "go" },
        -- root directory detection for detecting the project root
        -- root_dir = require("lspconfig.util").root_pattern("pack.pl"),
        settings = {
          gopls = {
            analyses = {
              deprecated = false, -- disable the deprecated analyzer which is expensive in beam
            },
          },
        },
      },
    })
  end,
}