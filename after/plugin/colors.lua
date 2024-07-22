function ColorMyPencils(color)
	color = color or "nolife"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
	--vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils()
-- require('noirbuddy').setup {
--     colors = {
--       background = '#000000',
--       primary = '#874fd6',
--       secondary = '#229986',
--       diagnostic_error = '#EC0034',
--       diagnostic_warning = '#ffffff',
--       diagnostic_info = '#229986',
--       diagnostic_hint = '#229986',
--       diff_add = '#95C72A',
--       diff_change = '#229986',
--       diff_delete = '#EC0034',
--     }
-- }
