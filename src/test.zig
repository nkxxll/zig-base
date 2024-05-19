const std = @import("std");
const print = std.debug.print;
pub fn inToOut(input: []const u8, allocator: std.mem.Allocator) ![]u8 {
    const output = try allocator.dupe(u8, input);
    return output;
}

pub fn ceil() void {
    const one = 1;
    const float = 2.25;
    const res = @ceil(@as(f32, @floatFromInt(one)) * float);
    std.log.warn("{} {} {} {}", .{ res, @TypeOf(res), one, float });
}

test "pointer slice" {
    const input = "hello world";
    const test_allocator = std.testing.allocator;
    const output = try inToOut(input, test_allocator);
    defer test_allocator.free(output);
    try std.testing.expect(std.mem.eql(u8, input, @ptrCast(output)));
}

test "ceil" {
    ceil();
}
