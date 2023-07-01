myMethodComputingFib2:arg
    ^ [
        |fib|

        [:n | n <= 1
                  ifTrue:[1]
                  ifFalse:[(fib value:(n - 1))+(fun value:(n - 2))]] value:arg.
    ] value.
