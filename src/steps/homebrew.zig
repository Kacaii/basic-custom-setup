//! This module handles installing all necessary formulaes (softwares)
//! using `brew install`.

const std = @import("std");

/// Starts the installation process.
pub fn init(allocator: std.mem.Allocator, root_node: std.Progress.Node) !void {
    const ensure_installed = [_][]const u8{
        "bat",
        "batdiff",
        "batgrep",
        "batman",
        "batpipe",
        "batwatch",
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
        "node",
        "nvim",
        "prettybat",
        "rg",
        "sqlite3",
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
        if (try checkInstall(allocator, formulae)) continue;

        const node_description = try std.fmt.allocPrint(allocator, "Installing {s}", .{formulae});
        defer allocator.free(node_description);

        const sub_node = installing_formulaes.start(node_description, 0);
        defer sub_node.end();

        const argv = [_][]const u8{ "brew", "install", formulae };
        const run_result = try std.process.Child.run(.{
            .allocator = allocator,
            .argv = &argv,
        });

        defer allocator.free(run_result.stdout);
        defer allocator.free(run_result.stderr);
    }
}

fn checkInstall(allocator: std.mem.Allocator, formulae: []const u8) !bool {
    const argv = [_][]const u8{ "which", formulae };
    const run_result = try std.process.Child.run(.{
        .allocator = allocator,
        .argv = &argv,
    });

    defer allocator.free(run_result.stdout);
    defer allocator.free(run_result.stderr);

    return run_result.term.Exited == 0;
}
