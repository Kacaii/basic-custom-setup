const builtin = @import("builtin");
const std = @import("std");
const Child = std.process.Child;
const Allocator = std.mem.Allocator;

const Homebrew = @import("./steps/homebrew.zig");

pub fn main() !void {
    var debug_allocator: std.heap.DebugAllocator(.{}) = .init;
    const allocator, const is_debug = switch (builtin.mode) {
        .Debug, .ReleaseSafe => .{ debug_allocator.allocator(), true },
        .ReleaseFast, .ReleaseSmall => .{ std.heap.smp_allocator, false },
    };

    defer if (is_debug) {
        _ = debug_allocator.deinit();
    };

    const root_node = std.Progress.start(.{ .root_name = "Running script" });
    defer root_node.end();

    // Install required formulaes 
    try Homebrew.init(allocator, root_node);
}
