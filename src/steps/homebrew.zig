const std = @import("std");
const Child = std.process.Child;
const Allocator = std.mem.Allocator;
const Node = std.Progress.Node;

pub fn init(allocator: Allocator, root_node: Node) !void {
    const ensure_installed = [_][]const u8{
        "bat",
        "bat-extras",
        "deno",
        "docker",
        "fd",
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
    };

    const installing_formulaes = root_node.start("Installing homebrew formulaes ", ensure_installed.len);
    defer installing_formulaes.end();

    for (ensure_installed) |formulae| {
        const node_description = try std.fmt.allocPrint(allocator, "Installing {s}", .{formulae});
        defer allocator.free(node_description);

        const sub_node = installing_formulaes.start(node_description, 0);
        defer sub_node.end();

        const argv = [_][]const u8{ "brew", "install", formulae };
        const brew_install_run = try Child.run(.{
            .allocator = allocator,
            .argv = &argv,
        });
        defer allocator.free(brew_install_run.stdout);
        defer allocator.free(brew_install_run.stderr);
    }
}
