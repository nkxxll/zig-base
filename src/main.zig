const base = @import("./base.zig");
const std = @import("std");
const print = std.debug.print;

// yes this is not that max but max for now
const MAX_BUF = 1024;

pub fn main() !void {
    var reader = std.io.getStdIn().reader();
    var input: [MAX_BUF]u8 = undefined;
    const allocator = std.heap.page_allocator;

    const read_bytes = reader.readAll(&input) catch |err| {
        print("err: {} -> input too large", .{err});
        return err;
    };

    const output = try base.base64Encode(input[0..read_bytes], allocator);
    defer allocator.free(output);

    print("Read: {d}\nOutput: {s}", .{ read_bytes, output });
}
