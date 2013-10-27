p ((Integer(dec1) rescue nil)) # => ArgumentError: invalid value for Integer: "0123459"
p Integer(dec1.sub(/^0+/,""))  # => 123459
p Integer("0d" + dec1)         # => 123459
p Integer("0x" + hex2)         # => 180154659
p Integer("0"  + oct3)         # => 4009
p Integer("0o" + oct3)         # => 4009
p Integer("0b" + bin4)         # => 345
