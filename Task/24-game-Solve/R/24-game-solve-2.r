> solve24()
8 * (4 - 2 + 1)
> solve24(c(6,7,9,5))
6 + (7 - 5) * 9
> solve24(c(8,8,8,8))
[1] NA
> solve24(goal=49) #different goal value
8 * (4 + 2) + 1
> solve24(goal=52) #no solution
[1] NA
> solve24(ops=c('-', '/')) #restricted set of operators
(8 - 2)/(1/4)
