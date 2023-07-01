# Build a Nothing type. When treated as a string it returns the string 'Nothing'.
# When treated as a Numeric, returns the value 'Nil'.
class NOTHING {
    method Str { 'Nothing' }
    method Numeric { Nil }
}

# A generic instance of a Nothing type.
my \Nothing = NOTHING.new;

# A reimplementation of the square-root function. Could just use the CORE one
# but this more fully shows how multi-dispatch candidates are added.

# Handle positive numbers & 0
multi root (Numeric $n where * >= 0) { $n.sqrt }
# Handle Negative numbers (Complex number handling is built in.)
multi root (Numeric $n where * <  0) { $n.Complex.sqrt }
# Else return Nothing
multi root ($n) { Nothing }

# Handle numbers > 0
multi ln (Real $n where * > 0) { log $n, e }
# Else return Nothing
multi ln ($n) { Nothing }

# Handle fraction where the denominator != 0
multi recip (Numeric $n where * != 0) { 1/$n }
# Else return Nothing
multi recip ($n) { Nothing }

# Helper formatting routine
sub center ($s) {
    my $pad = 21 - $s.Str.chars;
    ' ' x ($pad / 2).floor ~ $s ~ ' ' x ($pad / 2).ceiling;
}

# Display the "number" the reciprocal, the root, natural log and the 3 functions
# composed together.
put ('"Number"', 'Reciprocal', 'Square root', 'Natural log', 'Composed')».&center;

# Note how it handles the last two "values". The string 'WAT' is not numeric at
# all; but Ethiopic number 30, times vulgar fraction 1/7, is.
put ($_, .&recip, .&root, .&ln, .&(&ln o &root o &recip) )».&center
  for -2, -1, -0.5, 0, exp(-1), 1, 2, exp(1), 3, 4, 5, 'WAT', ፴ × ⅐;
