def quick_sort(sequence):
    lesser = []
    equal = []
    greater = []
    if len(sequence) <= 1:
        return sequence
    pivot = sequence[0]
    for element in sequence:
        if element < pivot:
            lesser.append(element)
        elif element > pivot:
            greater.append(element)
        else:
            equal.append(element)
    lesser = quick_sort(lesser)
    greater = quick_sort(greater)
    return lesser + equal + greater


a = [4, 65, 2, -31, 0, 99, 83, 782, 1]
a = quick_sort(a)
