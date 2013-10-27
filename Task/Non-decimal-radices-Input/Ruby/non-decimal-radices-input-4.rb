p dec1.to_i(0)      # => 5349 (which is 12345 in octal, the 9 is discarded)
p ("0d" + dec1).to_i(0)        # => 123459
p ("0x" + hex2).to_i(0)        # => 180154659
p ("0"  + oct3).to_i(0)        # => 4009
p ("0o" + oct3).to_i(0)        # => 4009
p ("0b" + bin4).to_i(0)        # => 345
