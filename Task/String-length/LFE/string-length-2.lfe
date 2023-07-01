> (set encoded (binary ("𝔘𝔫𝔦𝔠𝔬𝔡𝔢 𝔗𝔢𝒙𝔱" utf8)))
#B(240 157 148 152 240 157 148 171 240 157 ...)
> (byte_size encoded)
45
> (set bytes (binary ("𝔘𝔫𝔦𝔠𝔬𝔡𝔢 𝔗𝔢𝒙𝔱")))
#B(24 43 38 32 44 33 34 32 23 34 153 49)
> (byte_size bytes)
12
> (set encoded (binary ("ASCII text" utf8)))
#B(65 83 67 73 73 32 116 101 120 116)
> (byte_size encoded)
10
