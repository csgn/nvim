vim.api.nvim_create_user_command(
    "CreateFile",
    function(opts)
        local current_dir = vim.fn.expand("%:h")
        local filename = opts.args
        if filename == "" then
            print("Please provide a filename")
            return
        end
        local new_file_path = current_dir .. "/" .. filename
        vim.cmd("!touch " .. new_file_path)
    end,
    { nargs = 1, desc = "Create a new file" }
)

vim.api.nvim_create_user_command(
    "DeleteFile",
    function(opts)
        local current_dir = vim.fn.expand("%:h")
        local filename = opts.args
        if filename == "" then
            print("Please provide a filename")
            return
        end
        local new_file_path = current_dir .. "/" .. filename
        vim.cmd("!rm " .. new_file_path)
    end,
    { nargs = 1, desc = "Delete the file" }
)

vim.api.nvim_create_user_command(
    "MkdirP",
    function(opts)
        local current_dir = vim.fn.expand("%:h")
        local dirname = opts.args
        if dirname == "" then
            print("Please provide a directory name")
            return
        end
        local new_dir_path = current_dir .. "/" .. dirname
        vim.cmd("!mkdir -p " .. new_dir_path)
    end,
    { nargs = 1, desc = "Make directory" }
)

vim.api.nvim_create_user_command(
    "Rmdir",
    function(opts)
        local current_dir = vim.fn.expand("%:h")
        local dirname = opts.args
        if dirname == "" then
            print("Please provide a directory name")
            return
        end
        local dir_path = current_dir .. "/" .. dirname
        vim.cmd("!rm -rf " .. dir_path)
    end,
    { nargs = 1, desc = "Remove directory" }
)
