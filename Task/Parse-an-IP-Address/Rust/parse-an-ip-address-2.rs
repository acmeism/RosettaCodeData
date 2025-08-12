use std::net::{Ipv4Addr, Ipv6Addr};

#[derive(Debug, Clone, Copy)]
pub enum IpAddr {
    V4([u8; 4]),
    V6([u8; 16]),
}

#[derive(Debug)]
pub struct ParseResult {
    pub addr: IpAddr,
    pub port: Option<u16>,
    pub consumed: usize,
}

pub struct Parser<'a> {
    input: &'a str,
    cursor: usize,
}

impl<'a> Parser<'a> {
    fn new(input: &'a str) -> Self {
        Self { input, cursor: 0 }
    }

    fn current_char(&self) -> Option<char> {
        self.input.chars().nth(self.cursor)
    }

    fn peek_char(&self, offset: usize) -> Option<char> {
        self.input.chars().nth(self.cursor + offset)
    }

    fn advance(&mut self) {
        if self.cursor < self.input.len() {
            self.cursor += 1;
        }
    }

    fn find_char(&self, ch: char) -> Option<usize> {
        self.input[self.cursor..].find(ch).map(|pos| self.cursor + pos)
    }

    fn parse_decimal(&mut self) -> Result<u32, &'static str> {
        let start = self.cursor;
        let mut val = 0u32;

        while let Some(ch) = self.current_char() {
            if ch.is_ascii_digit() {
                val = val.checked_mul(10).ok_or("decimal overflow")?;
                val = val.checked_add((ch as u32) - ('0' as u32)).ok_or("decimal overflow")?;
                self.advance();
            } else {
                break;
            }
        }

        if self.cursor == start {
            Err("no digits found")
        } else {
            Ok(val)
        }
    }

    fn parse_hex(&mut self) -> Result<u32, &'static str> {
        let start = self.cursor;
        let mut val = 0u32;

        while let Some(ch) = self.current_char() {
            let digit = match ch {
                '0'..='9' => (ch as u32) - ('0' as u32),
                'a'..='f' => (ch as u32) - ('a' as u32) + 10,
                'A'..='F' => (ch as u32) - ('A' as u32) + 10,
                _ => break,
            };

            val = val.checked_shl(4).ok_or("hex overflow")?;
            val = val.checked_add(digit).ok_or("hex overflow")?;
            self.advance();
        }

        if self.cursor == start {
            Err("no hex digits found")
        } else {
            Ok(val)
        }
    }

    fn parse_ipv4(&mut self) -> Result<[u8; 4], &'static str> {
        let mut addr = [0u8; 4];

        for i in 0..4 {
            let val = self.parse_decimal()?;
            if val > 255 {
                return Err("IPv4 octet out of range");
            }
            addr[i] = val as u8;

            if i < 3 {
                if self.current_char() != Some('.') {
                    return Err("expected '.' in IPv4 address");
                }
                self.advance();
            }
        }

        Ok(addr)
    }

    fn parse_ipv6(&mut self) -> Result<[u8; 16], &'static str> {
        let mut addr = [0u8; 16];
        let mut groups = Vec::new();
        let mut compression_pos = None;
        let mut has_ipv4_suffix = false;

        // Handle brackets
        let has_brackets = self.current_char() == Some('[');
        if has_brackets {
            self.advance();
        }

        // Parse groups
        loop {
            let start_cursor = self.cursor;

            // Check for empty group (compression)
            if self.current_char() == Some(':') {
                if compression_pos.is_some() {
                    // Check if this is the end of the address
                    if groups.len() == 0 || (groups.len() == 1 && compression_pos == Some(0)) {
                        break;
                    }
                    return Err("multiple :: compressions not allowed");
                }

                compression_pos = Some(groups.len());
                self.advance();

                // Handle leading ::
                if groups.is_empty() && self.current_char() == Some(':') {
                    self.advance();
                }
                continue;
            }

            // Try to parse hex
            match self.parse_hex() {
                Ok(val) => {
                    if val > 0xFFFF {
                        return Err("IPv6 group out of range");
                    }

                    // Check for IPv4 suffix
                    if self.current_char() == Some('.') {
                        // Rewind and parse as IPv4
                        self.cursor = start_cursor;
                        let ipv4_addr = self.parse_ipv4()?;

                        // Validate IPv4-mapped IPv6 prefix
                        if groups.len() != 6 ||
                           groups[0..5] != [0, 0, 0, 0, 0] ||
                           groups[5] != 0xFFFF {
                            return Err("IPv4 suffix only allowed in ::ffff: mapping");
                        }

                        // Add IPv4 bytes as two 16-bit groups
                        groups.push(((ipv4_addr[0] as u16) << 8) | (ipv4_addr[1] as u16));
                        groups.push(((ipv4_addr[2] as u16) << 8) | (ipv4_addr[3] as u16));
                        has_ipv4_suffix = true;
                        break;
                    }

                    groups.push(val as u16);

                    // Check for continuation
                    if self.current_char() == Some(':') {
                        self.advance();
                    } else {
                        break;
                    }
                }
                Err(_) => {
                    if groups.is_empty() {
                        return Err("invalid IPv6 format");
                    }
                    break;
                }
            }
        }

        // Handle compression
        if let Some(pos) = compression_pos {
            let groups_after = groups.len() - pos;
            let zeros_needed = 8 - groups.len();

            if zeros_needed > 0 {
                let mut new_groups = Vec::new();
                new_groups.extend_from_slice(&groups[..pos]);
                new_groups.resize(new_groups.len() + zeros_needed, 0);
                new_groups.extend_from_slice(&groups[pos..]);
                groups = new_groups;
            }
        }

        if groups.len() != 8 {
            return Err("IPv6 address must have 8 groups");
        }

        // Convert to bytes
        for (i, &group) in groups.iter().enumerate() {
            addr[i * 2] = (group >> 8) as u8;
            addr[i * 2 + 1] = (group & 0xFF) as u8;
        }

        // Validate IPv4-mapped address
        if has_ipv4_suffix {
            let ipv4_mapped_prefix = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0xFF, 0xFF];
            if addr[..12] != ipv4_mapped_prefix {
                return Err("invalid IPv4-mapped IPv6 address");
            }
        }

        // Handle closing bracket
        if has_brackets {
            if self.current_char() != Some(']') {
                return Err("expected closing bracket");
            }
            self.advance();
        }

        Ok(addr)
    }

    fn parse_port(&mut self) -> Result<u16, &'static str> {
        if self.current_char() != Some(':') {
            return Err("expected ':' before port");
        }
        self.advance();

        let port = self.parse_decimal()?;
        if port > 65535 {
            return Err("port out of range");
        }

        Ok(port as u16)
    }
}

pub fn parse_ipv4_or_ipv6(input: &str) -> Result<ParseResult, &'static str> {
    let mut parser = Parser::new(input);

    // Determine if this looks like IPv6
    let colon_pos = parser.find_char(':');
    let dot_pos = parser.find_char('.');
    let bracket_pos = parser.find_char('[');

    let is_ipv6 = bracket_pos.is_some()
        || dot_pos.is_none()
        || (colon_pos.is_some() && (dot_pos.is_none() || colon_pos < dot_pos));

    let addr = if is_ipv6 {
        IpAddr::V6(parser.parse_ipv6()?)
    } else {
        IpAddr::V4(parser.parse_ipv4()?)
    };

    let port = if parser.current_char() == Some(':') {
        Some(parser.parse_port()?)
    } else {
        None
    };

    Ok(ParseResult {
        addr,
        port,
        consumed: parser.cursor,
    })
}

// Helper function for compatibility
pub fn parse_ipv4_or_ipv6_simple(input: &str) -> Result<(IpAddr, Option<u16>, bool), &'static str> {
    let result = parse_ipv4_or_ipv6(input)?;
    let is_ipv6 = matches!(result.addr, IpAddr::V6(_));
    Ok((result.addr, result.port, is_ipv6))
}

fn dump_bytes(bytes: &[u8]) {
    for &byte in bytes {
        print!("{:02x}", byte);
    }
}

fn test_case(input: &str) {
    println!("Test case '{}'", input);

    match parse_ipv4_or_ipv6(input) {
        Ok(result) => {
            print!("addr:  ");
            match result.addr {
                IpAddr::V4(addr) => dump_bytes(&addr),
                IpAddr::V6(addr) => dump_bytes(&addr),
            }
            println!();

            if let Some(port) = result.port {
                println!("port:  {}", port);
            } else {
                println!("port absent");
            }
        }
        Err(e) => {
            println!("parse failed: {}", e);
        }
    }
    println!();
}

fn main() {
    // The "localhost" IPv4 address
    test_case("127.0.0.1");

    // The "localhost" IPv4 address, with a specified port (80)
    test_case("127.0.0.1:80");

    // The "localhost" IPv6 address
    test_case("::1");

    // The "localhost" IPv6 address, with a specified port (80)
    test_case("[::1]:80");

    // Rosetta Code's primary server's public IPv6 address
    test_case("2605:2700:0:3::4713:93e3");

    // Rosetta Code's primary server's public IPv6 address, with a specified port (80)
    test_case("[2605:2700:0:3::4713:93e3]:80");

    // IPv4 space
    test_case("::ffff:192.168.173.22");

    // IPv4 space with port
    test_case("[::ffff:192.168.173.22]:80");

    // Trailing compression
    test_case("1::");

    // Trailing compression with port
    test_case("[1::]:80");

    // 'any' address compression
    test_case("::");

    // 'any' address compression with port
    test_case("[::]:80");
}
