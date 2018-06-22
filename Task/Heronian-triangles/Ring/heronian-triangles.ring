# Project : Heronian triangles
# Date    : 2017/11/04
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

see "Heronian triangles with sides up to 200" + nl
see "Sides               Perimeter       Area" + nl
for n = 1 to 200
    for m = n to 200
       for p = m to 200
           s = (n + m + p) / 2
           w = sqrt(s * (s - n) * (s - m) * (s - p))
           bool = (gcd(n, m) = 1 or gcd(n, m) = n) and (gcd(n, p) = 1 or gcd(n, p) = n) and (gcd(m, p) = 1 or gcd(m, p) = m)
           if w = floor(w) and w > 0 and bool
              see "{" + n + ", " + m + ", " + p + "}" + "              " + s*2 + "              " + w + nl
           ok
       next
    next
next
see nl

see "Heronian triangles with area 210:" + nl
see "Sides               Perimeter       Area" + nl
for n = 1 to 150
    for m = n to 150
        for p = m to 150
            s = (n + m + p) / 2
            w = sqrt(s * (s - n) * (s - m) * (s - p))
            bool = (gcd(n, m) = 1 or gcd(n, m) = n) and (gcd(n, p) = 1 or gcd(n, p) = n) and (gcd(m, p) = 1 or gcd(m, p) = m)
            if w = 210 and bool
               see "{" + n + ", " + m + ", " + p + "}" + "              " + s*2 + "              " + w + nl
            ok
        next
    next
next

func gcd(gcd, b)
       while b
               c   = gcd
               gcd = b
               b   = c % b
       end
       return gcd
