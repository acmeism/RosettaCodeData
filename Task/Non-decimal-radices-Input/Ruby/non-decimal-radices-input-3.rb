dec1.to_i(0)      # => 5349 (which is 12345 in octal, the 9 is discarded)
dec1.sub(/^0+/,"").to_i(0)   # => 123459
("0x" + hex2).to_i(0)        # => 180154659
("0"  + oct3).to_i(0)        # => 4009
("0b" + bin4).to_i(0)        # => 345
