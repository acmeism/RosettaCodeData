> -- create queue:
> q = {}
> -- push:
> q[#q+1] = "first"
> q[#q+1] = "second"
> q[#q+1] = "third"
> -- pop:
> =table.remove(q, 1)
first
> =table.remove(q, 1)
second
> =table.remove(q, 1)
third
> -- empty?
> =#q == 0
true
