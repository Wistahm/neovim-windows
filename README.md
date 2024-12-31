As a Linux user, I've been trying to configure neovim on my Windows 11 machine recently to make it as productive and as fast as possible for Go programming.
After a couple of attempts of failure to setup neovim properly on Windows (it was really excruciating, specially with the nvim-treesitter), I found out that [NvChad](https://nvchad.com/) is the best solution.
It has most of the necessary plugins in it, and it's pretty straight forward to customize it as you want it to be.

But the real problem was `nvim-treesitter`, and for that I also found out that the easiest solution is [zig](https://ziglang.org).
So before using this config, make sure you have zig installed on your machine. You can do so using [chocolatey](https://chocolatey.org/) package manager.

## Dependencies:
Neovim (0.8.0 or later)</br>
Go</br>
Zig
