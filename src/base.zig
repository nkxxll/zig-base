const std = @import("std");

fn translate64(char: u8) u8 {
    return switch (char) {
        0 => 'A',
        1 => 'B',
        2 => 'C',
        3 => 'D',
        4 => 'E',
        5 => 'F',
        6 => 'G',
        7 => 'H',
        8 => 'I',
        9 => 'J',
        10 => 'K',
        11 => 'L',
        12 => 'M',
        13 => 'N',
        14 => 'O',
        15 => 'P',
        16 => 'Q',
        17 => 'R',
        18 => 'S',
        19 => 'T',
        20 => 'U',
        21 => 'V',
        22 => 'W',
        23 => 'X',
        24 => 'Y',
        25 => 'Z',
        26 => 'a',
        27 => 'b',
        28 => 'c',
        29 => 'd',
        30 => 'e',
        31 => 'f',
        32 => 'g',
        33 => 'h',
        34 => 'i',
        35 => 'j',
        36 => 'k',
        37 => 'l',
        38 => 'm',
        39 => 'n',
        40 => 'o',
        41 => 'p',
        42 => 'q',
        43 => 'r',
        44 => 's',
        45 => 't',
        46 => 'u',
        47 => 'v',
        48 => 'w',
        49 => 'x',
        50 => 'y',
        51 => 'z',
        52 => '0',
        53 => '1',
        54 => '2',
        55 => '3',
        56 => '4',
        57 => '5',
        58 => '6',
        59 => '7',
        60 => '8',
        61 => '9',
        62 => '+',
        63 => '/',
        else => unreachable,
    };
}

fn firstOctToSix(first: u8) u8 {
    return (first & 0b11111100) >> 2;
}

fn secondOctToSix(first: u8, second: u8) u8 {
    return (((first & 0b00000011) << 4) | ((second & 0b11110000) >> 4));
}

fn thridOctToSix(second: u8, third: u8) u8 {
    return (((second & 0b00001111) << 2) | ((third & 0b11000000) >> 6));
}

fn fourthOctToSix(third: u8) u8 {
    return (third & 0b00111111);
}

pub fn base64Encode(input: []const u8, allocator: std.mem.Allocator) ![]u8 {
    var i: usize = 2;
    var j: usize = 0;
    const input_len = input.len;
    const output_len = if (input_len % 3 == 0) (input_len / 3) * 4 else (input_len / 3) * 4 + 4;

    var output = try allocator.alloc(u8, output_len);

    while (i < input.len) : ({
        i += 3;
        j += 4;
    }) {
        output[j] = translate64(firstOctToSix(input[i - 2]));
        output[j + 1] = translate64(secondOctToSix(input[i - 2], input[i - 1]));
        output[j + 2] = translate64(thridOctToSix(input[i - 1], input[i]));
        output[j + 3] = translate64(fourthOctToSix(input[i]));
    }

    // i is an index input len is the lenght of the input string
    const rest = 3 - input_len % 3;
    switch (rest) {
        3 => {
            std.debug.print("perfect fit", .{});
        },
        2 => {
            output[j] = translate64(firstOctToSix(input[i - 2]));
            output[j + 1] = translate64(secondOctToSix(input[i - 2], 0));
            output[j + 2] = '=';
            output[j + 3] = '=';
        },
        1 => {
            output[j] = translate64(firstOctToSix(input[i - 2]));
            output[j + 1] = translate64(secondOctToSix(input[i - 2], input[i - 1]));
            output[j + 2] = translate64(thridOctToSix(input[i - 1], 0));
            output[j + 3] = '=';
        },
        else => {
            unreachable;
        },
    }

    return output;
}

fn decode64(char: u8) u8 {
    std.log.warn("{}", .{char});
    return switch (char) {
        'A' => 0,
        'B' => 1,
        'C' => 2,
        'D' => 3,
        'E' => 4,
        'F' => 5,
        'G' => 6,
        'H' => 7,
        'I' => 8,
        'J' => 9,
        'K' => 10,
        'L' => 11,
        'M' => 12,
        'N' => 13,
        'O' => 14,
        'P' => 15,
        'Q' => 16,
        'R' => 17,
        'S' => 18,
        'T' => 19,
        'U' => 20,
        'V' => 21,
        'W' => 22,
        'X' => 23,
        'Y' => 24,
        'Z' => 25,
        'a' => 26,
        'b' => 27,
        'c' => 28,
        'd' => 29,
        'e' => 30,
        'f' => 31,
        'g' => 32,
        'h' => 33,
        'i' => 34,
        'j' => 35,
        'k' => 36,
        'l' => 37,
        'm' => 38,
        'n' => 39,
        'o' => 40,
        'p' => 41,
        'q' => 42,
        'r' => 43,
        's' => 44,
        't' => 45,
        'u' => 46,
        'v' => 47,
        'w' => 48,
        'x' => 49,
        'y' => 50,
        'z' => 51,
        '0' => 52,
        '1' => 53,
        '2' => 54,
        '3' => 55,
        '4' => 56,
        '5' => 57,
        '6' => 58,
        '7' => 59,
        '8' => 60,
        '9' => 61,
        '+' => 62,
        '/' => 63,
        '=' => 0,
        else => unreachable,
    };
}

fn firstSixToOct(first: u8, second: u8) u8 {
    const tf = decode64(first);
    const ts = decode64(second);
    return tf << 2 | ts >> 6;
}

fn secondSixToOct(first: u8, second: u8) u8 {
    const tf = decode64(first);
    const ts = decode64(second);
    return tf << 4 | ts >> 4;
}

fn thridSixToOct(first: u8, second: u8) u8 {
    const tf = decode64(first);
    const ts = decode64(second);
    return tf << 6 | ts >> 2;
}

pub fn base64Decode(input: []const u8, allocator: std.mem.Allocator) ![]u8 {
    const input_len = input.len;
    var i: usize = 0;
    var j: usize = 0;
    var output = try allocator.alloc(u8, (input_len / 4) * 3);
    while (i < input_len) : ({
        i += 4;
        j += 3;
    }) {
        output[j] = firstSixToOct(input[i], input[i + 1]);
        output[j + 1] = secondSixToOct(input[i + 1], input[i + 2]);
        output[j + 2] = thridSixToOct(input[i + 2], input[i + 3]);
    }

    // var end: usize = input_len;
    // if (input_len != 0) {
    //     if (input[input_len - 2] == '=') {
    //         end -= 2;
    //     } else if (input[input_len - 1] == '=') {
    //         end -= 1;
    //     }
    // }
    // return output[0..end];
    return output;
}

test "BASE64_1" {
    const ta = std.testing.allocator;
    const input = "";
    const expected = "";
    const output = try base64Encode(input, ta);
    defer ta.free(output);
    try std.testing.expect(std.mem.eql(u8, output, expected));
}

test "BASE64_2" {
    const input = "f";
    const expected = "Zg==";
    const ta = std.testing.allocator;
    const output = try base64Encode(input, ta);
    defer ta.free(output);
    try std.testing.expect(std.mem.eql(u8, output, expected));
}
test "BASE64_3" {
    const input = "fo";
    const expected = "Zm8=";
    const ta = std.testing.allocator;
    const output = try base64Encode(input, ta);
    defer ta.free(output);
    try std.testing.expect(std.mem.eql(u8, output, expected));
}
test "BASE64_4" {
    const input = "foo";
    const expected = "Zm9v";
    const ta = std.testing.allocator;
    const output = try base64Encode(input, ta);
    defer ta.free(output);
    try std.testing.expect(std.mem.eql(u8, output, expected));
}
test "BASE64_5" {
    const input = "foob";
    const expected = "Zm9vYg==";
    const ta = std.testing.allocator;
    const output = try base64Encode(input, ta);
    defer ta.free(output);
    try std.testing.expect(std.mem.eql(u8, output, expected));
}
test "BASE64_6" {
    const input = "fooba";
    const expected = "Zm9vYmE=";
    const ta = std.testing.allocator;
    const output = try base64Encode(input, ta);
    defer ta.free(output);
    try std.testing.expect(std.mem.eql(u8, output, expected));
}
test "BASE64_7" {
    const input = "foobar";
    const expected = "Zm9vYmFy";
    const ta = std.testing.allocator;
    const output = try base64Encode(input, ta);
    defer ta.free(output);
    try std.testing.expect(std.mem.eql(u8, output, expected));
}

test "BASE64_1decode" {
    const ta = std.testing.allocator;
    const input = "";
    const expected = "";
    const output = try base64Decode(input, ta);
    defer ta.free(output);
    if (std.mem.eql(u8, output, expected)) {
        std.log.warn("not the same: output {s} expected {s}", .{ output, expected });
    }
    try std.testing.expect(std.mem.eql(u8, output, expected));
}

test "BASE64_2decode" {
    const expected = "f";
    const input = "Zg==";
    const ta = std.testing.allocator;
    const output = try base64Decode(input, ta);
    defer ta.free(output);
    std.log.warn("not the same: output {s} expected {s}", .{ output, expected });
    try std.testing.expect(std.mem.eql(u8, output, expected));
}

test "BASE64_3decode" {
    const expected = "fo";
    const input = "Zm8=";
    const ta = std.testing.allocator;
    const output = try base64Decode(input, ta);
    defer ta.free(output);
    std.log.warn("not the same: output {s} expected {s}", .{ output, expected });
    try std.testing.expect(std.mem.eql(u8, output, expected));
}

test "BASE64_4decode" {
    const expected = "foo";
    const input = "Zm9v";
    const ta = std.testing.allocator;
    const output = try base64Decode(input, ta);
    defer ta.free(output);
    std.log.warn("not the same: output {s} expected {s}", .{ output, expected });
    try std.testing.expect(std.mem.eql(u8, output, expected));
}

test "BASE64_5decode" {
    const expected = "foob";
    const input = "Zm9vYg==";
    const ta = std.testing.allocator;
    const output = try base64Decode(input, ta);
    defer ta.free(output);
    std.log.warn("not the same: output {s} expected {s}", .{ output, expected });
    try std.testing.expect(std.mem.eql(u8, output, expected));
}

test "BASE64_6decode" {
    const expected = "fooba";
    const input = "Zm9vYmE=";
    const ta = std.testing.allocator;
    const output = try base64Decode(input, ta);
    defer ta.free(output);
    std.log.warn("not the same: output {s} expected {s}", .{ output, expected });
    try std.testing.expect(std.mem.eql(u8, output, expected));
}

test "BASE64_7decode" {
    const expected = "foobar";
    const input = "Zm9vYmFy";
    const ta = std.testing.allocator;
    const output = try base64Decode(input, ta);
    defer ta.free(output);
    std.log.warn("not the same: output {s} expected {s}", .{ output, expected });
    try std.testing.expect(std.mem.eql(u8, output, expected));
}
// test "BASE32_1" {
//     const input = "";
//     const expected = "";
//     const output = base64Encode(input);
//     try std.testing.expect(output == expected);
// }
// test "BASE32_2" {
//     const input = "f";
//     const expected = "MY======";
//     const output = base64Encode(input);
//     try std.testing.expect(output == expected);
// }
// test "BASE32_3" {
//     const input = "fo";
//     const expected = "MZXQ====";
//     const output = base64Encode(input);
//     try std.testing.expect(output == expected);
// }
// test "BASE32_4" {
//     const input = "foo";
//     const expected = "MZXW6===";
//     const output = base64Encode(input);
//     try std.testing.expect(output == expected);
// }
// test "BASE32_5" {
//     const input = "foob";
//     const expected = "MZXW6YQ=";
//     const output = base64Encode(input);
//     try std.testing.expect(output == expected);
// }
// test "BASE32_6" {
//     const input = "fooba";
//     const expected = "MZXW6YTB";
//     const output = base64Encode(input);
//     try std.testing.expect(output == expected);
// }
// test "BASE32_7" {
//     const input = "foobar";
//     const expected = "MZXW6YTBOI======";
//     const output = base64Encode(input);
//     try std.testing.expect(output == expected);
// }
// test "BASE32-HEX_1" {
//     const input = "";
//     const expected = "";
//     const output = base64Encode(input);
//     try std.testing.expect(output == expected);
// }
// test "BASE32-HEX_2" {
//     const input = "f";
//     const expected = "CO======";
//     const output = base64Encode(input);
//     try std.testing.expect(output == expected);
// }
// test "BASE32-HEX_3" {
//     const input = "fo";
//     const expected = "CPNG====";
//     const output = base64Encode(input);
//     try std.testing.expect(output == expected);
// }
// test "BASE32-HEX_4" {
//     const input = "foo";
//     const expected = "CPNMU===";
//     const output = base64Encode(input);
//     try std.testing.expect(output == expected);
// }
// test "BASE32-HEX_5" {
//     const input = "foob";
//     const expected = "CPNMUOG=";
//     const output = base64Encode(input);
//     try std.testing.expect(output == expected);
// }
// test "BASE32-HEX_6" {
//     const input = "fooba";
//     const expected = "CPNMUOJ1";
//     const output = base64Encode(input);
//     try std.testing.expect(output == expected);
// }
// test "BASE32-HEX_7" {
//     const input = "foobar";
//     const expected = "CPNMUOJ1E8======";
//     const output = base64Encode(input);
//     try std.testing.expect(output == expected);
// }
// test "BASE16_1" {
//     const input = "";
//     const expected = "";
//     const output = base64Encode(input);
//     try std.testing.expect(output == expected);
// }
// test "BASE16_2" {
//     const input = "f";
//     const expected = "66";
//     const output = base64Encode(input);
//     try std.testing.expect(output == expected);
// }
// test "BASE16_3" {
//     const input = "fo";
//     const expected = "666F";
//     const output = base64Encode(input);
//     try std.testing.expect(output == expected);
// }
// test "BASE16_4" {
//     const input = "foo";
//     const expected = "666F6F";
//     const output = base64Encode(input);
//     try std.testing.expect(output == expected);
// }
// test "BASE16_5" {
//     const input = "foob";
//     const expected = "666F6F62";
//     const output = base64Encode(input);
//     try std.testing.expect(output == expected);
// }
// test "BASE16_6" {
//     const input = "fooba";
//     const expected = "666F6F6261";
//     const output = base64Encode(input);
//     try std.testing.expect(output == expected);
// }
// test "BASE16_7" {
//     const input = "foobar";
//     const expected = "666F6F626172";
//     const output = base64Encode(input);
//     try std.testing.expect(output == expected);
// }
