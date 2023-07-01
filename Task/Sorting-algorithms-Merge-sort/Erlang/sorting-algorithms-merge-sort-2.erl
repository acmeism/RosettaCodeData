pMergeSort(L) when length(L) == 1 -> L;
pMergeSort(L) when length(L) > 1 ->
    {L1, L2} = lists:split(length(L) div 2, L),
    spawn(mergesort, pMergeSort2, [L1, self()]),
    spawn(mergesort, pMergeSort2, [L2, self()]),
    mergeResults([]).

pMergeSort2(L, Parent) when length(L) == 1 -> Parent ! L;
pMergeSort2(L, Parent) when length(L) > 1 ->
    {L1, L2} = lists:split(length(L) div 2, L),
    spawn(mergesort, pMergeSort2, [L1, self()]),
    spawn(mergesort, pMergeSort2, [L2, self()]),
    Parent ! mergeResults([]).
