n & 1 == 0
quotient, remainder = n.divmod(2); remainder == 0

# The next way only works when n.to_f/2 is exact.
# If Float is IEEE double, then -2**53 .. 2**53 must include n.
n.to_f/2 == n/2

# You can use the bracket operator to access the i'th bit
# of a Fixnum or Bignum (i = 0 means least significant bit)
n[0].zero?
