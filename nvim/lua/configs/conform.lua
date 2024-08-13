local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettierd" },
    nix = { "nixfmt" },
    zsh = { "shfmt" },
    sh = { "shfmt" },
    yaml = { "yq" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    json = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

require("conform").setup(options)
