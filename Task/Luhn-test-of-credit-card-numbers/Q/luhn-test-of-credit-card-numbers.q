sd:{s:0; while[x<>0; s+:x mod 10; x:floor x%10]; s}    / Sum digits of x
luhn:{
    r:reverse string x;                             / Reversed credit card number
    o:("I"$) each r[2*til ceiling (count r) % 2];   / Odd-indexed numbers
    e:("I"$) each r[1+2*til floor (count r) % 2];   / Even-indexed numbers
    0=(sum o,sd each e*2) mod 10                    / Return 1b if checksum ends in 0; 0b otherwise
}
