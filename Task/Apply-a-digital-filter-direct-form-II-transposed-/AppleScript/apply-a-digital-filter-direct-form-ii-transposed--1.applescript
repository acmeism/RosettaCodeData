on min(a, b)
    if (b < a) then return b
    return a
end min

on DF2TFilter(a, b, sig)
    set aCount to (count a)
    set bCount to (count b)
    set sigCount to (count sig)
    set rst to {}

    repeat with i from 1 to sigCount
        set tmp to 0
        set iPlus1 to i + 1
        repeat with j from 1 to min(i, bCount)
            set tmp to tmp + (item j of b) * (item (iPlus1 - j) of sig)
        end repeat
        repeat with j from 2 to min(i, aCount)
            set tmp to tmp - (item j of a) * (item (iPlus1 - j) of rst)
        end repeat
        set end of rst to tmp / (beginning of a)
    end repeat

    return rst
end DF2TFilter

local acoef, bcoef, signal
set acoef to {1.0, -2.77555756E-16, 0.333333333, -1.85037171E-17}
set bcoef to {0.16666667, 0.5, 0.5, 0.16666667}
set signal to {-0.917843918645, 0.141984778794, 1.20536903482, 0.190286794412, ¬
    -0.662370894973, -1.00700480494, -0.404707073677, 0.800482325044, ¬
    0.743500089861, 1.01090520172, 0.741527555207, 0.277841675195, ¬
    0.400833448236, -0.2085993586, -0.172842103641, -0.134316096293, ¬
    0.025930339848, 0.490105989562, 0.549391221511, 0.9047198589}
DF2TFilter(acoef, bcoef, signal)
