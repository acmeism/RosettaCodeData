split = { list ->
    list.collate((list.size()+1)/2 as int)
}

merge = { left, right, headBuffer=[] ->
    if(left.size() == 0) headBuffer+right
    else if(right.size() == 0) headBuffer+left
    else if(left.head() <= right.head()) merge.trampoline(left.tail(), right, headBuffer+left.head())
    else merge.trampoline(right.tail(), left, headBuffer+right.head())
}.trampoline()

mergesort = { List list ->
    if(list.size() < 2) list
    else merge(split(list).collect {mergesort it})
}

assert mergesort((500..1)) == (1..500)
assert mergesort([5,4,6,3,1,2]) == [1,2,3,4,5,6]
assert mergesort([3,3,1,4,6,78,9,1,3,5]) == [1,1,3,3,3,4,5,6,9,78]
