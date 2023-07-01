# A slice just contains the first and last value
let alpha: Slice[char] = 'a'..'z'
echo alpha # (a: a, b: z)

# but can be used to check if a character is in it:
echo 'f' in alpha # true
echo 'G' in alpha # false

# A set contains all elements as a bitvector:
let alphaSet: set[char] = {'a'..'z'}
echo alphaSet # {a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z}
echo 'f' in alphaSet # true
var someChars = {'a','f','g'}
echo someChars <= alphaSet # true

import sequtils
# A sequence:
let alphaSeq = toSeq 'a'..'z'
echo alphaSeq # @[a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z]
echo alphaSeq[10] # k
