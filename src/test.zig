const std = @import("std");
pub fn inToOut(input: []const u8, allocator: std.mem.Allocator) ![]u8 {
    const output = try allocator.dupe(u8, input);
    return output;
}

test "pointer slice" {
    const input = "hello world";
    const test_allocator = std.testing.allocator;
    const output = try inToOut(input, test_allocator);
    defer test_allocator.free(output);
    try std.testing.expect(std.mem.eql(u8, input, @ptrCast(output)));
}
