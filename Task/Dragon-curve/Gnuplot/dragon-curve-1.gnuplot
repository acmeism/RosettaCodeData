# Return the position of the highest 1-bit in n.
# The least significant bit is position 0.
# For example n=13 is binary "1101" and the high bit is pos=3.
# If n==0 then the return is 0.
# Arranging the test as n>=2 avoids infinite recursion if n==NaN (any
# comparison involving NaN is always false).
#
high_bit_pos(n) = (n>=2 ? 1+high_bit_pos(int(n/2)) : 0)

# Return 0 or 1 for the bit at position "pos" in n.
# pos==0 is the least significant bit.
#
bit(n,pos) = int(n / 2**pos) & 1

# dragon(n) returns a complex number which is the position of the
# dragon curve at integer point "n".  n=0 is the first point and is at
# the origin {0,0}.  Then n=1 is at {1,0} which is x=1,y=0, etc.  If n
# is not an integer then the point returned is for int(n).
#
# The calculation goes by bits of n from high to low.  Gnuplot doesn't
# have iteration in functions, but can go recursively from
# pos=high_bit_pos(n) down to pos=0, inclusive.
#
# mul() rotates by +90 degrees (complex "i") at bit transitions 0->1
# or 1->0.  add() is a vector (i+1)**pos for each 1-bit, but turned by
# factor "i" when in a "reversed" section of curve, which is when the
# bit above is also a 1-bit.
#
dragon(n) = dragon_by_bits(n, high_bit_pos(n))
dragon_by_bits(n,pos) \
  = (pos>=0 ? add(n,pos) + mul(n,pos)*dragon_by_bits(n,pos-1)  : 0)

add(n,pos) = (bit(n,pos) ? (bit(n,pos+1) ? {0,1} * {1,1}**pos   \
                                         :         {1,1}**pos)  \
              : 0)
mul(n,pos) = (bit(n,pos) == bit(n,pos+1) ? 1 : {0,1})

# Plot the dragon curve from 0 to "length" with line segments.
# "trange" and "samples" are set so the parameter t runs through
# integers t=0 to t=length inclusive.
#
# Any trange works, it doesn't have to start at 0.  But must have
# enough "samples" that all integers t in the range are visited,
# otherwise vertices in the curve would be missed.
#
length=256
set trange [0:length]
set samples length+1
set parametric
set key off
plot real(dragon(t)),imag(dragon(t)) with lines
