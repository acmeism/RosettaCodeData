Integer(dec1)     # => ArgumentError: invalid value for Integer: "0123459"
Integer(dec1.sub(/^0+/,""))  # => 123459
Integer("0x" + hex2)         # => 180154659
Integer("0"  + oct3)         # => 4009
Integer("0b" + bin4)         # => 345
