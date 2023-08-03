-- Read uthe docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
lvim.colorscheme = "dracula"
-- lvim.keys.normal_mode["n"] = ":BufferLineCycleNext<CR>"
-- lvim.keys.normal_mode["N"] = ":BufferLineCyclePrev<CR>"
lvim.plugins = {
  "lunarvim/darkplus.nvim",
  'neovim/nvim-lspconfig',
  'jose-elias-alvarez/null-ls.nvim',
  'MunifTanjim/prettier.nvim',
  'MunifTanjim/eslint.nvim',
  'Mofiqul/dracula.nvim',
  -- load required null-ls references
  -- local methods = require("null-ls.methods")
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
local null_ls = require("null-ls")
local eslint = require("eslint")

null_ls.setup()

eslint.setup({
  bin = 'eslint', -- or `eslint_d`
  code_actions = {
    enable = true,
    apply_on_save = {
      enable = true,
      types = { "directive", "problem", "suggestion", "layout" },
    },
    disable_rule_comment = {
      enable = true,
      location = "separate_line", -- or `same_line`
    },
  },
  diagnostics = {
    enable = true,
    report_unused_disable_directives = false,
    run_on = "type", -- or `save`
  },
})
