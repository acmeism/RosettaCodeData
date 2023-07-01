see lcm(24,36)

func lcm m,n
     lcm = m*n / gcd(m,n)
     return lcm

func gcd gcd, b
     while b
           c   = gcd
           gcd = b
           b   = c % b
     end
     return gcd
