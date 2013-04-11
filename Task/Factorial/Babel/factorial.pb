main:
    { argv 0 th $d
    fac
    %d cr << }

fac!:
    { dup zero?
        { dup one?
            { cp 1 - fac * }
            { zap 1 }
        if }
        { zap 1 }
    if }

one?! : { 1 = }
zero?!: { 0 = }
