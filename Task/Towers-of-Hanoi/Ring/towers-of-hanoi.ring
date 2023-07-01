move(4, 1, 2, 3)

func move n, src, dst, via
     if n > 0 move(n - 1, src, via, dst)
        see "" + src + " to " + dst + nl
        move(n - 1, via, dst, src) ok
