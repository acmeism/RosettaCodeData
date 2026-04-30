codepoints = [0x41, 0xF6, 0x416, 0x20AC, 0x1D11E]

codepoints.each do |codepoint1|
  # Int#chr returns a Char with that unicode codepoint
  char = codepoint1.chr

  # Char#bytes returns an array of bytes with itself encoded in UTF-8
  bytes = char.bytes

  # A String can be created from a Slice of bytes encoded in UTF-8
  string = String.new(Slice.new(bytes.to_unsafe, bytes.size))

  # Indexing a string, the first Char can be extracted
  char2 = string[0]

  # Char#ord returns its codepoint as an integer. The roundtrip is complete
  codepoint2 = char2.ord

  puts "U+%06x -> %-20s -> U+%06x  (%s)" % {codepoint1, bytes, codepoint2, char}
end
