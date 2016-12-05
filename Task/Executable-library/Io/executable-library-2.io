counts := Map clone
for(n, 1, 100000-1,
    out := HailStone sequence(n)
    key := out size asCharacter
    counts atPut(key, counts atIfAbsentPut(key, 0) + 1)
)

maxCount := counts values max
lengths := list()
counts foreach(k,v,
    if(v == maxCount, lengths append(k at(0)))
)

if(lengths size == 1,
    writeln("The most frequent sequence length for n < 100,000 is ",lengths at(0),
        " occurring ",maxCount," times.")
,
    writeln("The most frequent sequence lengths for n < 100,000 are:\n",
        lengths join(",")," occurring ",maxCount," times each.")
)
