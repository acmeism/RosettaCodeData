use FixedInt;

# Instantiate a new 57(!) bit fixed size integer
my \fixedint = FixedInt.new: :57bits;

fixedint = (2³⁷ / 72 - 5¹⁷); # Set it to a large value

say fixedint;     # Echo the value to the console in decimal format
say fixedint.bin; # Echo the value to the console in binary format

fixedint.=C2;     # Take the twos complement

say fixedint;     # Echo the value to the console in decimal format
say fixedint.bin; # Echo the value to the console in binary format
