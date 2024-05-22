const std = @import("std");
const print = std.debug.print;
const base64 = std.base64;
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

test "base64 encode" {
    const hello = "hello";
    // I have a pointer to a 8 bytes long array that is not defined yet
    var array: [8]u8 = undefined;
    var res: []const u8 = &[_]u8{ 0, 0, 0, 0, 0, 0, 0, 0 };
    const encoder = base64.Base64Encoder.init(base64.standard_alphabet_chars, null);
    res = encoder.encode(&array, hello);
    std.log.warn("r:{s}, d:{s}, s:{s}", .{ res, array, hello });
}

pub fn main() !void {
    // fast lookup table
    var fast_char_to_index: [4][256]u32 = .{[_]u32{0} ** 256} ** 4;
    var char_to_index: [256]u8 = [_]u8{0} ** 256;
    for (base64.standard_alphabet_chars, 0..) |c, i| {
        const ci = @as(u32, @intCast(i));
        fast_char_to_index[0][c] = ci << 2;
        fast_char_to_index[1][c] = (ci >> 4) | ((ci & 0x0f) << 12);
        fast_char_to_index[2][c] = ((ci & 0x3) << 22) | ((ci & 0x3c) << 6);
        fast_char_to_index[3][c] = ci << 16;

        char_to_index[c] = @as(u8, @intCast(i));
    }
    for (fast_char_to_index) |row| {
        for (row) |col| {
            std.debug.print("{x} ", .{col});
        }
        std.debug.print("\n", .{});
    }
    for (char_to_index) |c| {
        print("{x}: {c}; ", .{ c, c });
    }
}
