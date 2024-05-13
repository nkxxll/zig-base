const std = @import("std");
const print = std.debug.print;

pub fn hello_base() void {
    print("hello base", .{});
}

pub fn base64Encode(input: []const u8, allocator: std.mem.Allocator) ![]u8 {
    var i: usize = 0;
    var j: usize = 0;
    var output = try allocator.alloc(u8, @ceil(input.len * 1.25));
    while (i < input.len) : ({
        i += 3;
        j += 4;
    }) {
        output[j] = input[i] & 0b00111111;
        output[j + 1] = (input[i] & 0b11000000) >> 6 | (input[i + 1] & 0b00001111) << 2;
        output[j + 2] = (input[i + 1] & 0b11110000) >> 4 | (input[i + 2] & 0b00000011) << 4;
        output[j + 3] = (input[i + 2] & 0b11111100) >> 2;
    }
    // pad the rest
    const rest = input.len % 4;
    for (output.len - rest..output.len) |r| {
        output[r] = '=';
    }
    return output;
}
pub fn base64Decode(input: []u8, output: []u8) void {}
pub fn base32Encode(input: []u8, output: []u8) void {}
pub fn base32Decode(input: []u8, output: []u8) void {}
pub fn base32HexEncode(input: []u8) []u8 {}
pub fn base32HexDecode(input: []u8) []u8 {}
pub fn base16Encode(input: []u8) []u8 {}
pub fn base16Decode(input: []u8) []u8 {}

test "BASE64_1" {
    const input: *const []u8 = "";
    const expected: *const []u8 = "";
    const output: [input.len]u8 = undefined;
    base32Encode(input, &output);
    try std.testing.expect(output == expected);
}
test "BASE64_2" {
    const input = "f";
    const expected = "Zg==";
    const output = base64Encode(input);
    try std.testing.expect(output == expected);
}
test "BASE64_3" {
    const input = "fo";
    const expected = "Zm8=";
    const output = base64Encode(input);
    try std.testing.expect(output == expected);
}
test "BASE64_4" {
    const input = "foo";
    const expected = "Zm9v";
    const output = base64Encode(input);
    try std.testing.expect(output == expected);
}
test "BASE64_5" {
    const input = "foob";
    const expected = "Zm9vYg==";
    const output = base64Encode(input);
    try std.testing.expect(output == expected);
}
test "BASE64_6" {
    const input = "fooba";
    const expected = "Zm9vYmE=";
    const output = base64Encode(input);
    try std.testing.expect(output == expected);
}
test "BASE64_7" {
    const input = "foobar";
    const expected = "Zm9vYmFy";
    const output = base64Encode(input);
    try std.testing.expect(output == expected);
}
test "BASE32_1" {
    const input = "";
    const expected = "";
    const output = base64Encode(input);
    try std.testing.expect(output == expected);
}
test "BASE32_2" {
    const input = "f";
    const expected = "MY======";
    const output = base64Encode(input);
    try std.testing.expect(output == expected);
}
test "BASE32_3" {
    const input = "fo";
    const expected = "MZXQ====";
    const output = base64Encode(input);
    try std.testing.expect(output == expected);
}
test "BASE32_4" {
    const input = "foo";
    const expected = "MZXW6===";
    const output = base64Encode(input);
    try std.testing.expect(output == expected);
}
test "BASE32_5" {
    const input = "foob";
    const expected = "MZXW6YQ=";
    const output = base64Encode(input);
    try std.testing.expect(output == expected);
}
test "BASE32_6" {
    const input = "fooba";
    const expected = "MZXW6YTB";
    const output = base64Encode(input);
    try std.testing.expect(output == expected);
}
test "BASE32_7" {
    const input = "foobar";
    const expected = "MZXW6YTBOI======";
    const output = base64Encode(input);
    try std.testing.expect(output == expected);
}
test "BASE32-HEX_1" {
    const input = "";
    const expected = "";
    const output = base64Encode(input);
    try std.testing.expect(output == expected);
}
test "BASE32-HEX_2" {
    const input = "f";
    const expected = "CO======";
    const output = base64Encode(input);
    try std.testing.expect(output == expected);
}
test "BASE32-HEX_3" {
    const input = "fo";
    const expected = "CPNG====";
    const output = base64Encode(input);
    try std.testing.expect(output == expected);
}
test "BASE32-HEX_4" {
    const input = "foo";
    const expected = "CPNMU===";
    const output = base64Encode(input);
    try std.testing.expect(output == expected);
}
test "BASE32-HEX_5" {
    const input = "foob";
    const expected = "CPNMUOG=";
    const output = base64Encode(input);
    try std.testing.expect(output == expected);
}
test "BASE32-HEX_6" {
    const input = "fooba";
    const expected = "CPNMUOJ1";
    const output = base64Encode(input);
    try std.testing.expect(output == expected);
}
test "BASE32-HEX_7" {
    const input = "foobar";
    const expected = "CPNMUOJ1E8======";
    const output = base64Encode(input);
    try std.testing.expect(output == expected);
}
test "BASE16_1" {
    const input = "";
    const expected = "";
    const output = base64Encode(input);
    try std.testing.expect(output == expected);
}
test "BASE16_2" {
    const input = "f";
    const expected = "66";
    const output = base64Encode(input);
    try std.testing.expect(output == expected);
}
test "BASE16_3" {
    const input = "fo";
    const expected = "666F";
    const output = base64Encode(input);
    try std.testing.expect(output == expected);
}
test "BASE16_4" {
    const input = "foo";
    const expected = "666F6F";
    const output = base64Encode(input);
    try std.testing.expect(output == expected);
}
test "BASE16_5" {
    const input = "foob";
    const expected = "666F6F62";
    const output = base64Encode(input);
    try std.testing.expect(output == expected);
}
test "BASE16_6" {
    const input = "fooba";
    const expected = "666F6F6261";
    const output = base64Encode(input);
    try std.testing.expect(output == expected);
}
test "BASE16_7" {
    const input = "foobar";
    const expected = "666F6F626172";
    const output = base64Encode(input);
    try std.testing.expect(output == expected);
}
