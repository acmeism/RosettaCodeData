List disjointSort := method(indices,
    sortedIndices := indices unique sortInPlace
    sortedValues := sortedIndices map(idx,at(idx)) sortInPlace
    sortedValues foreach(i,v,atPut(sortedIndices at(i),v))
    self
)

list(7,6,5,4,3,2,1,0) disjointSort(list(6,1,7)) println
