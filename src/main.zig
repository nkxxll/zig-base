const std = @import("std");

pub fn base64encode()  {
}

pub fn main() !void {
}

test "base 64 1" {
}

// BASE64("") = ""
// BASE64("f") = "Zg=="
// BASE64("fo") = "Zm8="
// BASE64("foo") = "Zm9v"
// BASE64("foob") = "Zm9vYg=="
// BASE64("fooba") = "Zm9vYmE="
// BASE64("foobar") = "Zm9vYmFy"
// BASE32("") = ""
// BASE32("f") = "MY======"
// BASE32("fo") = "MZXQ===="
// BASE32("foo") = "MZXW6==="
// BASE32("foob") = "MZXW6YQ="
// BASE32("fooba") = "MZXW6YTB"
// BASE32("foobar") = "MZXW6YTBOI======"
// BASE32-HEX("") = ""
// BASE32-HEX("f") = "CO======"
// BASE32-HEX("fo") = "CPNG===="
// BASE32-HEX("foo") = "CPNMU==="
// BASE32-HEX("foob") = "CPNMUOG="
// BASE32-HEX("fooba") = "CPNMUOJ1"
// BASE32-HEX("foobar") = "CPNMUOJ1E8======"
// BASE16("") = ""
// BASE16("f") = "66"
// BASE16("fo") = "666F"
// BASE16("foo") = "666F6F"
// BASE16("foob") = "666F6F62"
// BASE16("fooba") = "666F6F6261"
// BASE16("foobar") = "666F6F626172"
