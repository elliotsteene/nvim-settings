return {
    {
        'VVoruganti/today.nvim',
        cmd = "Today",
        config = function()
            require('today').setup()
        end
    }
}
