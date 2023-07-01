accumulator := method(sum,
    block(x, sum = sum + x) setIsActivatable(true)
)
x := accumulator(1)
x(5)
accumulator(3)
x(2.3) println  // --> 8.3000000000000007
