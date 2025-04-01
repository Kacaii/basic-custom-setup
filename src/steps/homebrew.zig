//! This module handles installing all necessary formulaes (softwares)
//! using `brew install`.

const std = @import("std");

/// Starts the installation process.
pub fn init(allocator: std.mem.Allocator, root_node: std.Progress.Node) !void {
    const ensure_installed = [_][]const u8{
        "bat",
        "bat-extras",
        "deno",
        "docker",
        "fd",
        "fish",
        "fish-lsp",
        "fzf",
        "gh",
        "ghq",
        "go",
        "httpie",
        "lazydocker",
        "lazygit",
        "lua",
        "luarocks",
        "neovim",
        "node",
        "php",
        "ripgrep",
        "sqlite",
        "tmux",
        "tree",
        "tree-sitter",
        "xclip",
        "yazi",
        "zig",
        "zoxide",
    };

    const installing_formulaes = root_node.start("Installing homebrew formulaes ", ensure_installed.len);
    defer installing_formulaes.end();

    for (ensure_installed) |formulae| {
        const node_description = try std.fmt.allocPrint(allocator, "Installing {s}", .{formulae});
        defer allocator.free(node_description);

        const sub_node = installing_formulaes.start(node_description, 0);
        defer sub_node.end();

        const argv = [_][]const u8{ "brew", "install", formulae };
        const brew_install_run = try std.process.Child.run(.{
            .allocator = allocator,
            .argv = &argv,
        });
        defer allocator.free(brew_install_run.stdout);
        defer allocator.free(brew_install_run.stderr);
    }
}
