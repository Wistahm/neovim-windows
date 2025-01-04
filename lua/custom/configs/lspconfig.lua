-- local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local util = require("lspconfig/util")

lspconfig.gopls.setup {
  on_attach = function(client, bufnr)
    require("core.utils").load_mappings("lspconfig", { buffer = bufnr })
    if client.server_capabilities.signatureHelpProvider then
    require("nvchad.signature").setup(client)
    end
    vim.api.nvim_exec([[
      augroup LspHighlight
        autocmd!
        autocmd CursorHold * lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved * lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)

    vim.cmd [[
      highlight LspReferenceRead cterm=bold ctermbg=DarkGrey guibg=#61a5c2
      highlight LspReferenceText cterm=bold ctermbg=DarkGrey guibg=#61a5c2
      highlight LspReferenceWrite cterm=bold ctermbg=DarkGrey guibg=#61a5c2
    ]]

  end,
  capabilities = capabilities,
  cmd = {"gopls"},
  filetypes = {"go", "gomod", "gowork", "gotmpl"},
  root_dir = util.root_pattern("go.mod", ".git", "go.work"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      staticcheck = true,
      gofumpt = true,
      analyses = {
        unusedparams = true,
        unreachable = true,
      },
    }
  }
}