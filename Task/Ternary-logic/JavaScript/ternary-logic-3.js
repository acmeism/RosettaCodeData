nand    = (a, b) => (a == false || b == false) ? true : (a == undefined || b == undefined) ? undefined : false
not     = (a)    => nand(a, a)
and     = (a, b) => not(nand(a, b))
or      = (a, b) => nand(not(a), not(b))
nor     = (a, b) => not(or(a, b))
implies = (a, b) => nand(a, not(b))
iff     = (a, b) => or(and(a, b), nor(a, b))
xor     = (a, b) => not(iff(a, b))
