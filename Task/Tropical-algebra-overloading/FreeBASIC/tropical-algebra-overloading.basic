#define Inf 1e300 * 1e300
#define tropicalAdd(x,y) iif((x > y), (x), (y))
#define tropicalMul(x,y) (x + y)
#define tropicalExp(x,y) iif(int(y) > 0, (x * y), 0)

Print "tropicalMul(2,-2) = "; tropicalMul(2,-2)
Print "tropicalAdd(-0.001,-Inf) = "; tropicalAdd(-0.001,-Inf)
Print "tropicalMul(0,-Inf) = "; tropicalMul(0,-Inf)
Print "tropicalAdd(1.5,-1) = "; tropicalAdd(1.5,-1)
Print "tropicalMul(-0.5,0) = "; tropicalMul(-0.5,0)
Print "tropicalExp(5,7) = "; tropicalExp(5,7)
Print "tropicalMul(5,tropicalAdd(8,7)) = "; tropicalMul(5,tropicalAdd(8,7))
Print "tropicalAdd(tropicalMul(5,8),tropicalMul(5,7)) = "; tropicalAdd(tropicalMul(5,8),tropicalMul(5,7))
Print "tropicalMul(5,tropicalAdd(8,7)) = tropicalAdd(tropicalMul(5,8),tropicalMul(5,7)) = "; _
CBool(tropicalMul(5,tropicalAdd(8,7)) = tropicalAdd(tropicalMul(5,8),tropicalMul(5,7)))

Sleep
