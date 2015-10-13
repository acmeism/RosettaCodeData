fib(n) = ([one(n) one(n) ; one(n) zero(n)]^n)[1,2]

ben(l) = [count(x->x==i, map(n->string(n)[1],l)) for i='1':'9']./length(l)

benford(l) = [Number[1:9;] ben(l) log10(1.+1./[1:9;])]
