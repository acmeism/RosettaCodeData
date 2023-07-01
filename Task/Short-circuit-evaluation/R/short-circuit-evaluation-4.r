> switchop(-1, a(1), b(1))
a called
[1] TRUE
> switchop(1, a(1), b(1))
a called
b called
[1] TRUE
> switchop(1, a(0), b(1))
a called
[1] FALSE
> switchop(0, a(0), b(1))
a called
b called
[1] TRUE
