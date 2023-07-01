sub group-chars ($str) { $str.comb: / (.) $0* / }

# Testing:

for Q[gHHH5YY++///\], Q[fff﻿﻿﻿n⃗n⃗n⃗»»»  ℵℵ☄☄☃☃̂☃🤔🇺🇸🤦‍♂️👨‍👩‍👧‍👦] -> $string {
    put 'Original: ', $string;
    put '   Split: ', group-chars($string).join(', ');
}
