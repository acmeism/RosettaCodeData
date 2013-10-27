# Textual strings are measured in characters (graphemes)
my $string = "abc";

# Arrays are measured in elements.
say $string.chars;     # 3
my @array = 1..5;
say @array.elems;      # 5

# Buffers may be viewed either as a byte-string or as an array of elements.
my $buffer = '#56997; means "four dragons".'.encode('utf8');
say $buffer.bytes;     # 26
say $buffer.elems;     # 26
