# Any numeric input value may use an underscore as a grouping/separator character.
# May occur in nearly any position, in any* number. * See restrictions below.

# Int
say 1_2_3;  # 123

# Binary Int
say 0b1_0_1_0_1; # 21

# Hexadecimal Int
say 0xa_bc_d; # 43981

# Rat
say 1_2_3_4.2_5; # 1234.25

# Num
say 6.0_22e4; # 60220

# There are some restrictions on the placement.
# An underscore may not be on an edge boundary, or next to another underscore.
# The following are all syntax errors.

# say _1234.25;
# say 1234_.25;
# say 1234._25;
# say 1234.25_;
# say 12__34.25;
