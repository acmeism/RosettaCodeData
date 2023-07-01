-- Accept an integer representing a codepoint.
-- Return the values of the individual octets.
function encode (codepoint)
  local codepoint_str = utf8.char(codepoint)
  local result = {}

  for i = 1, #codepoint_str do
    result[#result + 1] = string.unpack("B", codepoint_str, i)
  end

  return table.unpack(result)
end

-- Accept a variable number of octets.
-- Return the corresponding Unicode character.
function decode (...)
  local len = select("#", ...) -- the number of octets
  local fmt = string.rep("B", len)

  return string.pack(fmt, ...)
end

-- Run the given test cases.
function test_encode_decode ()
  -- "A", "ö", "Ж", "€", "𝄞"
  local tests = {tonumber("41", 16),  tonumber("f6", 16), tonumber("416", 16),
                  tonumber("20ac", 16), tonumber("1d11e", 16)}

  for i, test in ipairs(tests) do
    print("Char: ", test)
    print("Encoding: ", encode(test))
    print("Decoding: ", decode(encode(test)))
  end
end
