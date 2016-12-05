var # creation
  x = "this is a string"
  y = "this is another string"
  z = "this is a string"

if x == z: echo "x is z" # comparison

z = "now this is another string too" # assignment

y = z # copying

if x.len == 0: echo "empty" # check if empty

x.add('!') # append a byte

echo x[5..8] # substring
echo x[8 .. -1] # substring

z = x & y # join strings

import strutils

echo z.replace('t', 'T') # replace occurences of t with T
