for n = 1 to 15
    see catalan(n) + nl
next

func catalan n
     if n = 0 return 1 ok
     cat = 2 * (2 * n - 1) * catalan(n - 1) / (n + 1)
     return cat
