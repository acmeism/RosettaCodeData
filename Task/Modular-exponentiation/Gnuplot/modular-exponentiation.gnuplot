_powm(b, e, m, r) = (e == 0 ? r : (e % 2 == 1 ? _powm(b * b % m, e / 2, m, r * b % m) : _powm(b * b % m, e / 2, m, r)))
powm(b, e, m) = _powm(b, e, m, 1)
# Usage
print powm(2, 3453, 131)
# Where b is the base, e is the exponent, m is the modulus, i.e.: b^e mod m
