const base = @import("./base.zig");
const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    base.hello_base();
    print("Hello world!", .{});
}
