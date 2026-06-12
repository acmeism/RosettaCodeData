use std::fmt;

#[derive(Debug)]
struct UnescapeError {
    message: String,
}

impl UnescapeError {
    fn new(message: &str) -> Self {
        Self {
            message: message.to_string(),
        }
    }
}

impl fmt::Display for UnescapeError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}", self.message)
    }
}

impl std::error::Error for UnescapeError {}

fn parse_hex_digits(digits: &str) -> Result<u32, UnescapeError> {
    let mut code_point = 0u32;

    for digit in digits.chars() {
        code_point <<= 4;
        match digit {
            '0'..='9' => code_point |= (digit as u32) - ('0' as u32),
            'a'..='f' => code_point |= (digit as u32) - ('a' as u32) + 10,
            'A'..='F' => code_point |= (digit as u32) - ('A' as u32) + 10,
            _ => return Err(UnescapeError::new("invalid \\uXXXX escape")),
        }
    }

    Ok(code_point)
}

fn is_high_surrogate(code_point: u32) -> bool {
    code_point >= 0xD800 && code_point <= 0xDBFF
}

fn is_low_surrogate(code_point: u32) -> bool {
    code_point >= 0xDC00 && code_point <= 0xDFFF
}

fn encode_utf8(code_point: u32) -> Result<String, UnescapeError> {
    match std::char::from_u32(code_point) {
        Some(ch) => Ok(ch.to_string()),
        None => Err(UnescapeError::new("invalid code point")),
    }
}

fn unescape_json_string(input: &str) -> Result<String, UnescapeError> {
    let mut result = String::new();
    let bytes = input.as_bytes();
    let mut index = 0;
    let length = bytes.len();

    while index < length {
        let byte = bytes[index];
        index += 1;

        if byte == b'\\' {
            if index >= length {
                return Err(UnescapeError::new("invalid escape"));
            }

            let escape_char = bytes[index];
            index += 1;

            match escape_char {
                b'"' => result.push('"'),
                b'\\' => result.push('\\'),
                b'/' => result.push('/'),
                b'b' => result.push('\u{0008}'), // backspace
                b'f' => result.push('\u{000C}'), // form feed
                b'n' => result.push('\n'),
                b'r' => result.push('\r'),
                b't' => result.push('\t'),
                b'u' => {
                    // Decode 4 hex digits
                    if index + 4 > length {
                        return Err(UnescapeError::new("invalid \\uXXXX escape"));
                    }

                    let hex_str = std::str::from_utf8(&bytes[index..index + 4])
                        .map_err(|_| UnescapeError::new("invalid \\uXXXX escape"))?;

                    let code_point = parse_hex_digits(hex_str)?;
                    index += 4;

                    if is_low_surrogate(code_point) {
                        return Err(UnescapeError::new("unexpected low surrogate code point"));
                    }

                    let final_code_point = if is_high_surrogate(code_point) {
                        // Check for low surrogate pair
                        if index + 6 > length || bytes[index] != b'\\' || bytes[index + 1] != b'u' {
                            return Err(UnescapeError::new("incomplete escape sequence"));
                        }

                        let low_hex_str = std::str::from_utf8(&bytes[index + 2..index + 6])
                            .map_err(|_| UnescapeError::new("invalid \\uXXXX escape"))?;

                        let low_surrogate = parse_hex_digits(low_hex_str)?;
                        index += 6;

                        if !is_low_surrogate(low_surrogate) {
                            return Err(UnescapeError::new("unexpected code point"));
                        }

                        // Combine high and low surrogates into a Unicode code point
                        0x10000 + (((code_point & 0x03FF) << 10) | (low_surrogate & 0x03FF))
                    } else {
                        code_point
                    };

                    result.push_str(&encode_utf8(final_code_point)?);
                }
                _ => return Err(UnescapeError::new("invalid escape")),
            }
        } else {
            // Handle UTF-8 sequences and validate control characters
            if (byte & 0x80) == 0 {
                // Single-byte code point (ASCII)
                if byte <= 0x1F {
                    return Err(UnescapeError::new("invalid character"));
                }
                result.push(byte as char);
            } else if (byte & 0xE0) == 0xC0 {
                // Two-byte UTF-8 sequence
                if index + 1 > length {
                    return Err(UnescapeError::new("invalid code point"));
                }

                let utf8_bytes = &bytes[index - 1..index + 1];
                let utf8_str = std::str::from_utf8(utf8_bytes)
                    .map_err(|_| UnescapeError::new("invalid code point"))?;
                result.push_str(utf8_str);
                index += 1;
            } else if (byte & 0xF0) == 0xE0 {
                // Three-byte UTF-8 sequence
                if index + 2 > length {
                    return Err(UnescapeError::new("invalid code point"));
                }

                let utf8_bytes = &bytes[index - 1..index + 2];
                let utf8_str = std::str::from_utf8(utf8_bytes)
                    .map_err(|_| UnescapeError::new("invalid code point"))?;
                result.push_str(utf8_str);
                index += 2;
            } else if (byte & 0xF8) == 0xF0 {
                // Four-byte UTF-8 sequence
                if index + 3 > length {
                    return Err(UnescapeError::new("invalid code point"));
                }

                let utf8_bytes = &bytes[index - 1..index + 3];
                let utf8_str = std::str::from_utf8(utf8_bytes)
                    .map_err(|_| UnescapeError::new("invalid code point"))?;
                result.push_str(utf8_str);
                index += 3;
            } else {
                return Err(UnescapeError::new("invalid character"));
            }
        }
    }

    Ok(result)
}

fn main() {
    let test_cases = vec![
        "abc",
        "a☺c",
        "a\\\"c",
        "\\u0061\\u0062\\u0063",
        "a\\\\c",
        "a\\u263Ac",
        "a\\\\u263Ac",
        "a\\uD834\\uDD1Ec",
        "a\\ud834\\udd1ec",
        "a\\u263",
        "a\\u263Xc",
        "a\\uDD1Ec",
        "a\\uD834c",
        "a\\uD834\\u263Ac",
    ];

    for test_case in test_cases {
        match unescape_json_string(test_case) {
            Ok(unescaped) => println!("{} -> {}", test_case, unescaped),
            Err(e) => println!("{} -> {}", test_case, e),
        }
    }
}
