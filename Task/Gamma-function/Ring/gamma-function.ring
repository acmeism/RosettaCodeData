decimals(3)
gamma = 0.577
coeff = -0.655
quad = -0.042
qui = 0.166
set = -0.042

for i=1 to 10
    see gammafunc(i / 3.0) + nl
next

func recigamma z
     return z + gamma * pow(z,2) + coeff * pow(z,3) + quad * pow(z,4) + qui * pow(z,5) + set * pow(z,6)

func gammafunc z
     if z = 1 return 1
     but fabs(z) <= 0.5 return 1 / recigamma(z)
     else return (z - 1) * gammafunc(z-1) ok
