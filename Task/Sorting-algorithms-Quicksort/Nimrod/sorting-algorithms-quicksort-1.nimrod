proc QuickSort(list: seq[int]): seq[int] =
    if len(list) == 0:
        return @[]

    var pivot = list[0]

    var left: seq[int] = @[]
    var right: seq[int] = @[]
    for i in low(list)+1..high(list):
        if list[i] <= pivot:
            left.add(list[i])
        elif list[i] > pivot:
            right.add(list[i])

    result = QuickSort(left)
    result.add(pivot)
    result.add(QuickSort(right))
