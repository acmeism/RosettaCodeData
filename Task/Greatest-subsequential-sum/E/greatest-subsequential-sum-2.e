def seq := [-1, -2, 3, 5, 6, -2, -1, 4, -4, 2, -1]
def [=> value, => indexes] := maxSubseq(seq)
println(`$\
Sequence: $seq
Maximum subsequence sum: $value
Indexes: ${indexes.getOptStart()}..${indexes.getOptBound().previous()}
Subsequence: ${seq(indexes.getOptStart(), indexes.getOptBound())}
`)
