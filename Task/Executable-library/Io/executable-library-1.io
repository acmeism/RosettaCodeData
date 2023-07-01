HailStone := Object clone
HailStone sequence := method(n,
    if(n < 1, Exception raise("hailstone: expect n >= 1 not #{n}" interpolate))
    n = n floor         // make sure integer value
    stones := list(n)
    while (n != 1,
        n = if(n isEven, n/2, 3*n + 1)
        stones append(n)
    )
    stones
)

if( isLaunchScript,
    out := HailStone sequence(27)
    writeln("hailstone(27) has length ",out size,": ",
        out slice(0,4) join(" ")," ... ",out slice(-4) join(" "))

    maxSize := 0
    maxN := 0
    for(n, 1, 100000-1,
        out = HailStone sequence(n)
        if(out size > maxSize,
            maxSize = out size
            maxN = n
        )
    )

    writeln("For numbers < 100,000, ", maxN,
    " has the longest sequence of ", maxSize, " elements.")
)
