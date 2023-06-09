local M = {}
local default_opts = { noremap = true }

vim.g.mapleader = " "

function M.setup()
  require("legendary").setup {
    keymaps = {
      -- Window split
      { "<C-k>", { n = "<C-w>k" }, description = "Jump to top window", default_opts }, 
      { "<C-j>", { n = "<C-w>j" }, description = "Jump to bottom window", default_opts }, 
      { "<C-h>", { n = "<C-w>h" }, description = "Jump to left window", default_opts },
      { "<C-l>", { n = "<C-w>l" }, description = "Jump to right window", default_opts },
      -- Window Split Resize
      { "<C-Up>", { n = ":resize +10<CR>" }, description = "Increase window height", default_opts },
      { "<C-Down>", { n = ":resize -10<CR>" }, description = "Decrease window height", default_opts },
      { "<C-Right>", { n = ":vertical resize +10<CR>" }, description = "Increase window width", default_opts },
      { "<C-Left>", { n = ":vertical resize -10<CR>" }, description = "Decrease window width", default_opts },
      -- Move lines
      { "<A-k>", { x = ":move '<-2<CR>gv-gv" }, description = "Move lines up", default_opts },
      { "<A-j>", { x = ":move '>+1<CR>gv-gv" }, description = "Move lines down", default_opts },
      -- Indent lines
      { "<", { v = "<gv" }, description = "Indent left", default_opts},
      { ">", { v = ">gv" }, description = "Indent right", default_opts},
      -- Switch between open files
      { "<S-l>", { n = ":bnext<CR>" }, description = "Next open file", default_opts },
      { "<S-h>", { n = ":bprevious<CR>"}, description = "Previous open file", default_opts },
      -- LSP diagnostics
      { "<leader>dp", { n = vim.diagnostic.open_float }, description = "Open diagnostic error popup", default_opts },
      { "<leader>dl", { n = vim.diagnostic.setloclist }, description = "Open diagnostic error list", default_opts },
      { "<leader>dk", { n = vim.diagnostic.goto_prev }, description = "Goto previous diagnostic error", default_opts },
      { "<leader>dj", { n = vim.diagnostic.goto_next }, description = "Goto next diagnostic error", default_opts },
      -- Explorer
      { "<C-e>", { n = ":NvimTreeToggle<CR>"}, description = "Open or close explorer", default_opts },
      -- Telescope
      { "<leader>f", ":Telescope<CR>", description = "open telescope", default_opts },
      { "<leader>ff", ":Telescope find_files<CR>", description = "Telescope find files", default_opts },
      { "<leader>fg", ":Telescope live_grep<CR>", description = "Telescope find in files", default_opts },
      { "<leader>fb", ":Telescope buffers<CR>", description = "Telescope list open files", default_opts },
      -- Legendary
      { "<C-p>", { n = function() require('legendary').find() end }, description = "Legendary command palette", default_opts },
      -- Terminal
      { "<leader>tt", { n = function() NTGlobal["terminal"]:toggle() end }, description = "Toggle terminal", default_opts },
      { "<leader>t1", { n = function() NTGlobal["terminal"]:open(1) end }, description = "Open terminal 1", default_opts },
      { "<leader>t2", { n = function() NTGlobal["terminal"]:open(2) end }, description = "Open terminal 1", default_opts },
      { "<leader>t3", { n = function() NTGlobal["terminal"]:open(3) end }, description = "Open terminal 3", default_opts },
      { "<leader>t4", { n = function() NTGlobal["terminal"]:open(4) end }, description = "Open terminal 4", default_opts },
      { "<leader>t5", { n = function() NTGlobal["terminal"]:open(5) end }, description = "Open terminal 5", default_opts },
    }
  }

  vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", default_opts)

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(event)
      local bufnr = event.buf
      local lsp_options = { buffer = bufnr }

      -- Enable completion triggered by <c-x><c-o>
      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

      require("legendary").setup {
        keymaps = {
          { "<leader>lD", { n = vim.lsp.buf.declaration }, description = "lsp jump to declaration", lsp_options },
          { "<leader>lt", { n = vim.lsp.buf.type_definition }, description = "lsp jump to type definition", lsp_options },
          { "<leader>li", { n = vim.lsp.buf.implementation }, description = "lsp jump to implementation", lsp_options },
          { "<leader>ld", { n = vim.lsp.buf.hover }, description = "lsp display definition", lsp_options },
          { "<leader>ls", { n = vim.lsp.buf.signature_help }, description = "lsp display signature", lsp_options },
          { "<leader>lr", { n = vim.lsp.buf.rename }, description = "lsp rename references", lsp_options },
          { "<leader>lf", { n = vim.lsp.buf.format }, description = "lsp format file", lsp_options },
          { "<leader>la", { n = vim.lsp.buf.code_action }, description = "lsp code action", lsp_options },
        }
      }
    end
  })
end

return M
