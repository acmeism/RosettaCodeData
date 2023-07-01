for n = 2008 to 2121
    if n < 2100 leap = n - 1900 else leap = n - 1904 ok
    m = (((n-1900)%7) + floor(leap/4) + 27) % 7
    if m = 4 see "25 Dec " + n + nl ok
next
