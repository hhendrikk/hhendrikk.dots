return {
  { import = "lazyvim.plugins.extras.dap.core" },

  -- desativa nvim-dap-ui
  { "rcarriga/nvim-dap-ui", enabled = false },

  -- nvim-dap principal
  {
    "mfussenegger/nvim-dap",
    init = function()
      vim.fn.sign_define("DapBreakpoint", {
        text = "▌",
        texthl = "DapBreakpoint",
        linehl = "",
        numhl = "",
      })

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#ff0000" })
        end,
      })

      vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#ff0000" })
    end,

    opts = function()
      local dap = require("dap")

      dap.adapters.coreclr = dap.adapters.coreclr
        or {
          type = "executable",
          command = "netcoredbg",
          args = { "--interpreter=vscode" },
        }

      local config = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
          end,
        },
      }

      dap.configurations.cs = config
      dap.configurations.fsharp = config
    end,
  },

  -- nvim-dap-view
  {
    "igorlfs/nvim-dap-view",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {},
    keys = {
      { "<leader>dv", "<cmd>DapViewToggle<cr>", desc = "Dap View Toggle" },
      { "<leader>dV", "<cmd>DapViewOpen<cr>", desc = "Dap View Open" },
      { "<leader>dc", "<cmd>DapViewClose<cr>", desc = "Dap View Close" },
    },
    config = function(_, opts)
      require("dap-view").setup(opts)

      local dap = require("dap")

      dap.listeners.before.event_terminated["dap_view_close"] = function()
        pcall(vim.cmd, "DapViewClose")
      end

      dap.listeners.before.event_exited["dap_view_close"] = function()
        pcall(vim.cmd, "DapViewClose")
      end
    end,
  },
}
