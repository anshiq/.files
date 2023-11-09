lvim.keys.normal_mode["L"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["H"] = ":BufferLineCyclePrev<CR>"
lvim.format_on_save.enabled = true
lvim.colorscheme = "dracula"
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.cmdheight = 0
lvim.plugins = {
    "lunarvim/darkplus.nvim",
    'neovim/nvim-lspconfig',
    'jose-elias-alvarez/null-ls.nvim',
    'MunifTanjim/prettier.nvim',
    'MunifTanjim/eslint.nvim',
    'Mofiqul/dracula.nvim',
    -- {
    --   url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    --   config = function()
    --     require("lsp_lines").setup()
    --   end,
    -- }
    -- {
    --       "tzachar/cmp-tabnine",
    --       run = "./install.sh",
    --       requires = "hrsh7th/nvim-cmp",
    --       config = function()
    --         local tabnine = require "cmp_tabnine.config"
    --         tabnine:setup {
    --           max_lines = 1000,
    --           max_num_results = 10,
    --           sort = true,
    --         }
    --       end,
    --       opt = true,
    --       event = "InsertEnter",
    --     },

}
-- vim.diagnostic.config({
--   virtual_text = false,
-- })
-- local null_ls = require("null-ls")
-- local eslint = require("eslint")


-- null_ls.setup()

-- eslint.setup({
--   bin = 'eslint', -- or `eslint_d`
--   code_actions = {
--     enable = true,
--     apply_on_save = {
--       enable = true,
--       types = { "directive", "problem", "suggestion", "layout" },
--     },
--     disable_rule_comment = {
--       enable = true,
--       location = "separate_line", -- or `same_line`
--     },
--   },
--   diagnostics = {
--     enable = true,
--     report_unused_disable_directives = false,
--     run_on = "type", -- or `save`
--   },
-- })
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
    { command = "eslint", filetypes = { "typescript", "typescriptreact" } }
}

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        command = "prettier",
        filetypes = { "typescript", "typescriptreact" },
    },
}
