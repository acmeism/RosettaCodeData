(length "ASCII text")
10
(length "𝔘𝔫𝔦𝔠𝔬𝔡𝔢 𝔗𝔢𝒙𝔱")
12
> (set encoded (binary ("𝔘𝔫𝔦𝔠𝔬𝔡𝔢 𝔗𝔢𝒙𝔱" utf8)))
#B(240 157 148 152 240 157 148 171 240 157 ...)
> (length (unicode:characters_to_list encoded 'utf8))
12
