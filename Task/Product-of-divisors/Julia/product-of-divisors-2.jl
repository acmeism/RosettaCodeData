proddivisors_oneliner(n) = prod(n%i==0 ? i : 1 for i in 1:n)
