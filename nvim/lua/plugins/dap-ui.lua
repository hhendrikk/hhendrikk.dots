return {
  "rcarriga/nvim-dap-ui",
  dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  opts = {
    floating = {
      max_height = 0.9,
      max_width = 0.5,
      border = "rounded",
      mappings = {
        close = { "q", "<Esc>" },
      },
    },
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.25 },
          { id = "breakpoints", size = 0.25 },
          { id = "stacks", size = 0.25 },
          { id = "watches", size = 0.25 },
        },
        position = "left",
        size = 30,
      },
      {
        elements = {
          { id = "console", size = 1.0 },
        },
        position = "bottom",
        size = 10,
      },
    },
  },
  config = function(_, opts)
    local dapui = require("dapui")
    dapui.setup(opts)

    vim.keymap.set("n", "<leader>di", function()
      require("dap.ui.widgets").hover()
    end)

    vim.keymap.set("n", "<leader>dr", function()
      dapui.float_element("repl", { enter = true, position = "center" })
    end, { desc = "REPL Flutuante" })

    local dap = require("dap")
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
  end,
}
