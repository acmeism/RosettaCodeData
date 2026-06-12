struct UnescapeError <: Exception
	message::String
	index::Int
end

function unescape_string(value)
	rv = Char[]
	len = length(value)
	index = 1
	start_index = 0
	while index <= len
		ch = value[index]
		if ch == '\\'
			index += 1  # Move past '\'
			if index > len
				throw(UnescapeError("incomplete escape sequence", index - 1))
			end
			if value[index] == '"'
				push!(rv, '"')
			elseif value[index] == '\\'
				push!(rv, '\\')
			elseif value[index] == '/'
				push!(rv, '/')
			elseif value[index] == 'b'
				push!(rv, '\x08')
			elseif value[index] == 'f'
				push!(rv, '\x0C')
			elseif value[index] == 'n'
				push!(rv, '\n')
			elseif value[index] == 'r'
				push!(rv, '\r')
			elseif value[index] == 't'
				push!(rv, '\t')
			elseif value[index] == 'u'
				start_index = index - 1
				codepoint, index = decode_hex_char(value, index)
				push!(rv, string_from_code_point(codepoint, start_index))
			else
				throw(UnescapeError("unknown escape sequence", index - 1))
			end
		else
			push!(rv, ch)
		end
		index += 1
	end
	return String(rv)
end

function decode_hex_char(value, index)
	len = length(value)
	if index + 4 > len
		throw(UnescapeError("incomplete escape sequence", index - 1))
	end
	index += 1  # Move past 'u'
	codepoint = parse_hex_digits(value[index:index+3], index - 2)

	if is_low_surrogate(codepoint)
		throw(UnescapeError("unexpected low surrogate code point", index - 2))
	end
	if is_high_surrogate(codepoint)
		if !(index + 9 <= len && value[index+4] == '\\' && value[index+5] == 'u')
			throw(UnescapeError("incomplete escape sequence", index - 2))
		end
		low_surrogate = parse_hex_digits(value[index+6:index+9], index + 4)
		if !is_low_surrogate(low_surrogate)
			throw(UnescapeError("unexpected code point", index + 4))
		end
		codepoint = 0x10000 + (((codepoint & 0x03ff) << 10) | (low_surrogate & 0x03ff))
		return codepoint, index + 9
	end
	return codepoint, index + 3
end

function parse_hex_digits(hexdigits, index)
	codepoint = zero(UInt32)
	for digit in hexdigits
		codepoint <<= 4
		if '0' <= digit <= '9'
			codepoint |= UInt32(digit) - UInt32('0')
		elseif 'A' <= digit <= 'F'
			codepoint |= UInt32(digit) - UInt32('A') + 10
		elseif 'a' <= digit <= 'f'
			codepoint |= UInt32(digit) - UInt32('a') + 10
		else
			throw(UnescapeError("invalid \\uXXXX escape sequence from $hexdigits", index))
		end
	end
	return codepoint
end

function string_from_code_point(codepoint, index)
	if codepoint isa Nothing || codepoint <= 0x1f
		throw(UnescapeError("invalid character", index))
	end
	try
		return Char(codepoint)
	catch err
		throw(UnescapeError("invalid escape sequence", index))
	end
end

is_high_surrogate(codepoint) = 0xd800 <= codepoint <= 0xdbff
is_low_surrogate(codepoint) = 0xdc00 <= codepoint <= 0xdfff

# Test cases
test_cases = [
	"abc",
	"a?c",
	"""a\\"c""",
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
]

for s in test_cases
	try
		println(s, " -> ", unescape_string(s))
	catch err
		println(s, " -> $(err.message), at index $(err.index - 1)")
	end
end
