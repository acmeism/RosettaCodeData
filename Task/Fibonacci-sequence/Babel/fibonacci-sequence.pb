main:
    { argv 0 th $d
    fib
    %d cr << }

fib!:
    { dup zero?
        { dup one?
            { cp <- 2 - fib -> 1 - fib + }
            { zap 1 }
        if }
        { zap 1 }
    if }

zero?!: { 0 = }

one?!: { 1 = }
