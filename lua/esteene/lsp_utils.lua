local M = {}

function M.goto_definition_split()
  local util = vim.lsp.util
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, 'textDocument/definition', params, function(err, result, ctx, _)
    if err then
      vim.notify('Error: ' .. err.message, vim.log.levels.ERROR)
      return
    end
    if not result or vim.tbl_isempty(result) then
      vim.notify('No definition found', vim.log.levels.INFO)
      return
    end
    if vim.tbl_islist(result) then
      vim.cmd('vsplit')
      util.jump_to_location(result[1])
    else
      vim.cmd('vsplit')
      util.jump_to_location(result)
    end
  end)
end

return M
