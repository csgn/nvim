function ColorMyPencils(color)
	color = color or "catppuccin"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "#07030d" })
	--vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils()