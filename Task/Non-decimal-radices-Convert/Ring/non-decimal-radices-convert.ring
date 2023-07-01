# Project : Non-decimal radices/Convert

see "0 (decimal) -> " + hex(0) + " (base 16)" + nl
see "26 (decimal) -> " + hex(26) + " (base 16)" + nl
see "383 (decimal) -> " + hex(383) + " (base 16)" + nl
see "26 (decimal) -> " + tobase(26, 2) + " (base 2)" + nl
see "383 (decimal) -> " + tobase(383, 2)  + " (base 2)" + nl
see "1a (base 16) -> " + dec("1a") + " (decimal)" + nl
see "1A (base 16) -> " + dec("1A") + " (decimal)" + nl
see "17f (base 16) -> " + dec("17f") + " (decimal)" + nl
see "101111111 (base 2) -> " + bintodec("101111111") + " (decimal)" + nl

func tobase(nr, base)
     binary = 0
     i = 1
     while(nr != 0)
           remainder = nr % base
           nr = floor(nr/base)
           binary= binary + (remainder*i)
           i = i*10
     end
     return string(binary)

func bintodec(bin)
     binsum = 0
     for n=1  to len(bin)
         binsum = binsum + number(bin[n]) *pow(2, len(bin)-n)
     next
     return binsum
