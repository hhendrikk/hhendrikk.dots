return {
  "GustavEikaas/easy-dotnet.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
    "folke/snacks.nvim",
    {
      "folke/which-key.nvim",
      optional = true,
      opts = {
        spec = {
          { "<leader>cD", group = ".NET" },
          { "<leader>cDd", group = "Database" },
          { "<leader>cDm", group = "Migrations" },
          { "<leader>cDl", group = "LSP" },
          { "<leader>cDp", group = "Package" },
        },
      },
    },
  },
  config = function()
    local dotnet = require("easy-dotnet")
    require("easy-dotnet").setup({
      managed_terminal = {
        auto_hide = true, -- auto hides terminal if exit code is 0
        auto_hide_delay = 1000, -- delay before auto hiding, 0 = instant
      },
      -- Optional configuration for external terminals (matches nvim-dap structure)
      external_terminal = nil,
      lsp = {
        enabled = true, -- Enable builtin roslyn lsp
        set_fold_expr = false,
        preload_roslyn = true, -- Start loading roslyn before any buffer is opened
        roslynator_enabled = true, -- Automatically enable roslynator analyzer
        easy_dotnet_analyzer_enabled = true, -- Enable roslyn analyzer from easy-dotnet-server
        auto_refresh_codelens = true,
        analyzer_assemblies = {}, -- Any additional roslyn analyzers you might use like SonarAnalyzer.CSharp
        config = {},
      },
      debugger = {
        -- Path to custom coreclr DAP adapter
        -- easy-dotnet-server falls back to its own netcoredbg binary if bin_path is nil
        bin_path = nil,
        console = "integratedTerminal", -- Controls where the target app runs: "integratedTerminal" (Neovim buffer) or "externalTerminal" (OS window)
        apply_value_converters = true,
        auto_register_dap = true,
        mappings = {
          open_variable_viewer = { lhs = "T", desc = "open variable viewer" },
        },
      },
      ---@type TestRunnerOptions
      test_runner = {
        auto_start_testrunner = true,
        hide_legend = false,
        ---@type "split" | "vsplit" | "float" | "buf"
        viewmode = "float",
        ---@type number|nil
        vsplit_width = nil,
        ---@type string|nil "topleft" | "topright"
        vsplit_pos = nil,
        icons = {
          passed = "",
          skipped = "",
          failed = "",
          success = "",
          reload = "",
          test = "",
          sln = "󰘐",
          project = "󰘐",
          dir = "",
          package = "",
          class = "",
          build_failed = "󰒡",
        },
        mappings = {
          run_test_from_buffer = { lhs = "<leader>r", desc = "run test from buffer" },
          run_all_tests_from_buffer = { lhs = "<leader>t", desc = "Run all tests in file" },
          get_build_errors = { lhs = "<leader>e", desc = "get build errors" },
          peek_stack_trace_from_buffer = { lhs = "<leader>p", desc = "peek stack trace from buffer" },
          debug_test_from_buffer = { lhs = "<leader>d", desc = "run test from buffer" },
          debug_test = { lhs = "<leader>d", desc = "debug test" },
          go_to_file = { lhs = "g", desc = "go to file" },
          run_all = { lhs = "<leader>R", desc = "run all tests" },
          run = { lhs = "<leader>r", desc = "run test" },
          peek_stacktrace = { lhs = "<leader>p", desc = "peek stacktrace of failed test" },
          expand = { lhs = "o", desc = "expand" },
          expand_node = { lhs = "E", desc = "expand node" },
          collapse_all = { lhs = "W", desc = "collapse all" },
          close = { lhs = "q", desc = "close testrunner" },
          refresh_testrunner = { lhs = "<C-r>", desc = "refresh testrunner" },
          cancel = { lhs = "<C-c>", desc = "cancel in-flight operation" },
        },
      },
      new = {
        project = {
          prefix = "sln", -- "sln" | "none"
        },
      },
      csproj_mappings = true,
      fsproj_mappings = true,
      auto_bootstrap_namespace = {
        --block_scoped, file_scoped
        type = "block_scoped",
        enabled = true,
        use_clipboard_json = {
          behavior = "prompt", --'auto' | 'prompt' | 'never',
          register = "+", -- which register to check
        },
      },
      server = {
        ---@type nil | "Off" | "Critical" | "Error" | "Warning" | "Information" | "Verbose" | "All"
        log_level = nil,
      },
      -- choose which picker to use with the plugin
      -- possible values are "telescope" | "fzf" | "snacks" | "basic"
      -- if no picker is specified, the plugin will determine
      -- the available one automatically with this priority:
      --  snacks -> fzf -> telescope ->  basic
      picker = "snacks",
      background_scanning = true,
      notifications = {
        --Set this to false if you have configured lualine to avoid double logging
        handler = function(start_event)
          local spinner = require("easy-dotnet.ui-modules.spinner").new()
          spinner:start_spinner(start_event.job.name)
          ---@param finished_event JobEvent
          return function(finished_event)
            spinner:stop_spinner(finished_event.result.msg, finished_event.result.level)
          end
        end,
      },
      diagnostics = {
        default_severity = "error",
        setqflist = false,
      },
    })

    -- Example command
    vim.api.nvim_create_user_command("Secrets", function()
      dotnet.secrets()
    end, {})

    -- Example keybinding
    vim.keymap.set("n", "<C-p>", function()
      dotnet.run_project()
    end)
  end,
  keys = {
    {
      "<leader>cDd",
      function()
        vim.cmd("Dotnet ef database update")
      end,
      desc = "Dotnet: EF Database Update",
    },
    {
      "<leader>cDdD",
      function()
        vim.cmd("Dotnet ef database drop")
      end,
      desc = "Dotnet: EF Database Drop",
    },
    {
      "<leader>cDma",
      function()
        vim.cmd("Dotnet ef migrations add")
      end,
      desc = "Dotnet: EF Add Migration",
    },
    {
      "<leader>cDmr",
      function()
        vim.cmd("Dotnet ef migrations remove")
      end,
      desc = "Dotnet: EF Remove Migration",
    },
    {
      "<leader>cDml",
      function()
        vim.cmd("Dotnet ef migrations list")
      end,
      desc = "Dotnet: EF List Migrations",
    },
    {
      "<leader>cDb",
      function()
        vim.cmd("Dotnet build quickfix")
      end,
      desc = "Dotnet: Build Project",
    },
    {
      "<leader>cDr",
      function()
        vim.cmd("Dotnet run")
      end,
      desc = "Dotnet: Run Project",
    },
    {
      "<leader>cDw",
      function()
        vim.cmd("Dotnet watch")
      end,
      desc = "Dotnet: Run with Watch",
    },
    {
      "<leader>cDt",
      function()
        vim.cmd("Dotnet test")
      end,
      desc = "Dotnet: Run Tests",
    },
    {
      "<leader>cDlr",
      function()
        vim.cmd("Dotnet lsp restart")
      end,
      desc = "Dotnet: Restart LSP",
    },
    {
      "<leader>cDls",
      function()
        vim.cmd("Dotnet lsp start")
      end,
      desc = "Dotnet: Start LSP",
    },
    {
      "<leader>cDlx",
      function()
        vim.cmd("Dotnet lsp stop")
      end,
      desc = "Dotnet: Stop LSP",
    },
    {
      "<leader>cDP",
      function()
        vim.cmd("Dotnet project view")
      end,
      desc = "Dotnet: Project View",
    },
    {
      "<leader>cDpo",
      function()
        vim.cmd("Dotnet outdated")
      end,
      desc = "Dotnet: Check Outdated Packages",
    },
    {
      "<leader>cDpp",
      function()
        vim.cmd("Dotnet pack")
      end,
      desc = "Dotnet: Pack Project",
    },
    {
      "<leader>cDpP",
      function()
        vim.cmd("Dotnet push")
      end,
      desc = "Dotnet: Push Package",
    },
    {
      "<leader>cDc",
      function()
        vim.cmd("Dotnet clean")
      end,
      desc = "Dotnet: Clean Project",
    },
    {
      "<leader>cDR",
      function()
        vim.cmd("Dotnet restore")
      end,
      desc = "Dotnet: Restore Packages",
    },
    {
      "<leader>cDn",
      function()
        vim.cmd("Dotnet new")
      end,
      desc = "Dotnet: New Project",
    },
    {
      "<leader>cDg",
      function()
        vim.cmd("checkhealth easy-dotnet")
      end,
      desc = "Dotnet: Check Health",
    },
    {
      "<leader>cDdS",
      function()
        vim.cmd("Dotnet diagnostic")
      end,
      desc = "Dotnet: Diagnostics",
    },
    {
      "<leader>cDde",
      function()
        vim.cmd("Dotnet diagnostic errors")
      end,
      desc = "Dotnet: Diagnostic Errors",
    },
    {
      "<leader>cDdw",
      function()
        vim.cmd("Dotnet diagnostic warnings")
      end,
      desc = "Dotnet: Diagnostic Warnings",
    },
  },
}
