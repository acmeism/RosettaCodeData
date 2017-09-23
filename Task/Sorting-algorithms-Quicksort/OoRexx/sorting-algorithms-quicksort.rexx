    a = .array~Of(4, 65, 2, -31, 0, 99, 83, 782, 1)
    say 'before:' a~toString( ,', ')
    a = quickSort(a)
    say ' after:' a~toString( ,', ')
    exit

::routine quickSort
    use arg arr -- the array to be sorted
    less = .array~new
    pivotList = .array~new
    more = .array~new
    if arr~items <= 1 then
        return arr
    else do
        pivot = arr[1]
        do i over arr
            if i < pivot then
                less~append(i)
            else if i > pivot then
                more~append(i)
            else
                pivotList~append(i)
        end
        less = quickSort(less)
        more = quickSort(more)
        return less~~appendAll(pivotList)~~appendAll(more)
    end
