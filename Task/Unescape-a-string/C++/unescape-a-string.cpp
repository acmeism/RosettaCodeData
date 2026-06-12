#include <exception>
#include <iostream>
#include <string> // c++17 for string_view
#include <vector>

class UnescapeError : public std::exception {
public:
  UnescapeError(std::string_view message) : m_message{message} {};
  const char* what() const noexcept override { return m_message.c_str(); };

private:
  std::string m_message{};
};

std::int32_t parse_hex_digits(std::string_view digits) {
  std::int32_t code_point{};

  for (const auto digit : digits) {
    code_point <<= 4;
    switch (digit) {
    case '0':
    case '1':
    case '2':
    case '3':
    case '4':
    case '5':
    case '6':
    case '7':
    case '8':
    case '9':
      code_point |= (digit - '0');
      break;
    case 'a':
    case 'b':
    case 'c':
    case 'd':
    case 'e':
    case 'f':
      code_point |= (digit - 'a' + 10);
      break;
    case 'A':
    case 'B':
    case 'C':
    case 'D':
    case 'E':
    case 'F':
      code_point |= (digit - 'A' + 10);
      break;
    default:
      throw UnescapeError("invalid \\uXXXX escape");
    }
  }
  return code_point;
}

bool is_high_surrogate(std::int32_t code_point) {
  return code_point >= 0xD800 && code_point <= 0xDBFF;
}

bool is_low_surrogate(std::int32_t code_point) {
  return code_point >= 0xDC00 && code_point <= 0xDFFF;
}

std::string encode_utf8(std::int32_t code_point) {
  std::string rv;

  if (code_point <= 0x7F) {
    // Single-byte UTF-8
    rv += static_cast<char>(code_point & 0x7F);
  } else if (code_point <= 0x7FF) {
    // Two-byte UTF-8
    rv += static_cast<char>(0xC0 | ((code_point >> 6) & 0x1F));
    rv += static_cast<char>(0x80 | (code_point & 0x3F));
  } else if (code_point <= 0xFFFF) {
    // Three-byte UTF-8
    rv += static_cast<char>(0xE0 | ((code_point >> 12) & 0x0F));
    rv += static_cast<char>(0x80 | ((code_point >> 6) & 0x3F));
    rv += static_cast<char>(0x80 | (code_point & 0x3F));
  } else if (code_point <= 0x10FFFF) {
    // Four-byte UTF-8
    rv += static_cast<char>(0xF0 | ((code_point >> 18) & 0x07));
    rv += static_cast<char>(0x80 | ((code_point >> 12) & 0x3F));
    rv += static_cast<char>(0x80 | ((code_point >> 6) & 0x3F));
    rv += static_cast<char>(0x80 | (code_point & 0x3F));
  } else {
    throw UnescapeError("invalid code point");
  }

  return rv;
}

std::string unescape_json_string(std::string_view sv) {
  std::string rv{};
  unsigned char byte{};    // current byte
  std::int32_t code_point; // decoded \uXXXX or \uXXXX\uXXXX escape sequence
  std::string::size_type index{0}; // current byte index in sv
  std::string::size_type length{sv.length()};

  while (index < length) {
    byte = sv[index++];

    if (byte == '\\') {
      if (index < length) {
        byte = sv[index++];
      } else {
        throw UnescapeError("invalid escape");
      }

      switch (byte) {
      case '"':
        rv.push_back('"');
        break;
      case '\\':
        rv.push_back('\\');
        break;
      case '/':
        rv.push_back('/');
        break;
      case 'b':
        rv.push_back('\b');
        break;
      case 'f':
        rv.push_back('\f');
        break;
      case 'n':
        rv.push_back('\n');
        break;
      case 'r':
        rv.push_back('\r');
        break;
      case 't':
        rv.push_back('\t');
        break;
      case 'u':
        // Decode 4 hex digits.
        if (index + 4 > length) {
          throw UnescapeError("invalid \\uXXXX escape");
        }

        code_point = parse_hex_digits(sv.substr(index, 4));
        index += 4;

        if (is_low_surrogate(code_point)) {
          throw UnescapeError("unexpected low surrogate code point");
        }

        if (is_high_surrogate(code_point)) {
          if (!(index + 6 <= length && sv[index] == '\\' &&
                  sv[index + 1] == 'u')) {
            throw UnescapeError("incomplete escape sequence");
          }

          std::int32_t low_surrogate =
              parse_hex_digits(sv.substr(index + 2, 4));
          index += 6;

          if (!is_low_surrogate(low_surrogate)) {
            throw UnescapeError("unexpected code point");
          }

          // Combine high and low surrogates into a Unicode code point.
          code_point = 0x10000 + (((code_point & 0x03FF) << 10) |
                                     (low_surrogate & 0x03FF));
        }

        rv.append(encode_utf8(code_point));
        break;
      default:
        throw UnescapeError("invalid escape");
      }
    } else {
      // Find invalid characters.
      // Bytes that are less than 0x1f and not a continuation byte.
      if ((byte & 0x80) == 0) {
        // Single-byte code point
        if (byte <= 0x1F) {
          throw UnescapeError("invalid character");
        }
        rv.push_back(byte);
      } else if ((byte & 0xE0) == 0xC0) {
        // Two-byte code point
        if (index + 1 > length) {
          throw UnescapeError("invalid code point");
        }
        rv.push_back(byte);
        rv.push_back(sv[index++]);
      } else if ((byte & 0xF0) == 0xE0) {
        // Three-byte code point
        if (index + 2 > length) {
          throw UnescapeError("invalid code point");
        }
        rv.push_back(byte);
        rv.push_back(sv[index++]);
        rv.push_back(sv[index++]);
      } else if ((byte & 0xF8) == 0xF0) {
        // Four-byte code point
        if (index + 3 > length) {
          throw UnescapeError("invalid code point");
        }
        rv.push_back(byte);
        rv.push_back(sv[index++]);
        rv.push_back(sv[index++]);
        rv.push_back(sv[index++]);
      } else {
        throw UnescapeError("invalid character");
      }
    }
  }

  return rv;
}

const std::vector<std::string> TEST_CASES = {
    "abc",
    "a\xE2\x98\xba" "c",
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
};

int main(int argc, char const* argv[]) {
  for (const auto& str : TEST_CASES) {
    try {
      auto unescaped{unescape_json_string(str)};
      std::cout << str << " -> " << unescape_json_string(str) << std::endl;
    } catch (const UnescapeError& e) {
      std::cout << str << " -> " << e.what() << std::endl;
    }
  }
  return 0;
}
