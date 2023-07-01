say e;            # e
say π; # or pi    # pi
say τ; # or tau   # tau

# Common mathmatical function are availble
# as subroutines and as numeric methods.
# It is a matter of personal taste and
# programming style as to which is used.
say sqrt 2;       # Square root
say 2.sqrt;       # Square root

# If you omit a base, does natural logarithm
say log 2;        # Natural logarithm
say 2.log;        # Natural logarithm

# Specify a base if other than e
say log 4, 10;    # Base 10 logarithm
say 4.log(10);    # Base 10 logarithm
say 4.log10;      # Convenience, base 10 only logarithm

say exp 7;        # Exponentiation base e
say 7.exp;        # Exponentiation base e

# Specify a base if other than e
say exp 7, 4;     # Exponentiation
say 7.exp(4);     # Exponentiation
say 4 ** 7;       # Exponentiation

say abs -2;       # Absolute value
say (-2).abs;     # Absolute value

say floor -3.5;   # Floor
say (-3.5).floor; # Floor

say ceiling pi;   # Ceiling
say pi.ceiling;   # Ceiling

say e ** π\i + 1 ≅ 0; # :-)
