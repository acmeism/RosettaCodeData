cross-sum: function [n][out: 0 foreach m form n [out: out + to-integer to-string m]]
additive-primes: function [n][collect [foreach p ps: primes n [if find ps cross-sum p [keep p]]]]

length? probe new-line/skip additive-primes 500 true 10
[
    2 3 5 7 11 23 29 41 43 47
    61 67 83 89 101 113 131 137 139 151
    157 173 179 191 193 197 199 223 227 229
    241 263 269 281 283 311 313 317 331 337
    353 359 373 379 397 401 409 421 443 449
    461 463 467 487
]
== 54
