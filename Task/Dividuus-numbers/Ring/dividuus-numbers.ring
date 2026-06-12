see  "Dividuus numbers are integers that are divisible by the sum of their digits, the product of their digits," + nl +
     "their digital root, and their multiplicative digital root." + nl

cnt = 0
i = 0

while cnt < 50
    i = i + 1
    if is_dividuus(i)
        cnt = cnt + 1
        see "" + i + " "
        if cnt%5 = 0
           see nl
        ok
    ok
end
see nl

func digsum n
    r = 0
    while n > 0
        r += n % 10
        n = floor(n / 10)
    end
    return r

func digprod n
    r = 1
    while n > 0
        r *= n % 10
        n = floor(n / 10)
    end
    if r !=0
       return r
    ok

func digroot n
    while n > 9  n = digsum(n) end
    return n

func mult n
    m = 1
    while n > 0
        dm = n % 10
        m *= dm
        n = floor(n / 10)
    end
    return m

func mult_digroot n
    m = n
    while m >= 10  m = mult(m) end
    return m

func is_dividuus n
    if n % digsum(n) != 0 return 0 ok
    if n % digprod(n) != 0 return 0 ok
    if n % digroot(n) != 0 return 0 ok
    mdr = mult_digroot(n)
    return (mdr != 0 and n % mdr = 0)
