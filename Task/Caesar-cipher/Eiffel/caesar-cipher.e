class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			s: STRING_32
		do
			s := "The tiny tiger totally taunted the tall Till."
			print ("%NString to encode: " + s)
			print ("%NEncoded string: " + encode (s, 12))
			print ("%NDecoded string (after encoding and decoding): " + decode (encode (s, 12), 12))
		end

feature		-- Basic operations

	decode (to_be_decoded: STRING_32; offset: INTEGER): STRING_32
				-- Decode `to be decoded' according to `offset'.
		do
			Result := encode (to_be_decoded, 26 - offset)
		end

	encode (to_be_encoded: STRING_32; offset: INTEGER): STRING_32
				-- Encode `to be encoded' according to `offset'.
		local
			l_offset: INTEGER
			l_char_code: INTEGER
		do
			create Result.make_empty
			l_offset := (offset \\ 26) + 26
			across to_be_encoded as tbe loop
				if tbe.item.is_alpha then
					if tbe.item.is_upper then
						l_char_code := ('A').code + (tbe.item.code - ('A').code + l_offset) \\ 26
						Result.append_character (l_char_code.to_character_32)
					else
						l_char_code := ('a').code + (tbe.item.code - ('a').code + l_offset) \\ 26
						Result.append_character (l_char_code.to_character_32)
					end
				else
					Result.append_character (tbe.item)
				end
			end
		end
end
