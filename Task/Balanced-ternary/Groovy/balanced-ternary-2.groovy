BalancedTernaryInteger a = new BalancedTernaryInteger('+-0++0+')
BalancedTernaryInteger b = new BalancedTernaryInteger(-436)
BalancedTernaryInteger c = new BalancedTernaryInteger(T.p, T.m, T.p, T.p, T.m)
BalancedTernaryInteger bmc = new BalancedTernaryInteger(-436 - (c as Integer))
BalancedTernaryInteger atbmc = new BalancedTernaryInteger((a as Integer) * (-436 - (c as Integer)))

printf ("%9s = %12s %8d\n", 'a', "${a}", a as Number)
printf ("%9s = %12s %8d\n", 'b', "${b}", b as Number)
printf ("%9s = %12s %8d\n", 'c', "${c}", c as Number)
assert (b-c) == bmc
printf ("%9s = %12s %8d\n", 'b-c', "${b-c}", (b-c) as Number)
assert (a * (b-c)) == atbmc
printf ("%9s = %12s %8d\n", 'a * (b-c)', "${a * (b-c)}", (a * (b-c)) as Number)

println "\nDemonstrate failure:"
assert (a * (b-c)) == a
