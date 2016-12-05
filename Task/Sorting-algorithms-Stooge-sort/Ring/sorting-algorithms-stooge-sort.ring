test = [4, 65, 2, -31, 0, 99, 2, 83, 782, 1]
stoogeSort(test, 1, len(test))
for i = 1 to 10
    see "" + test[i] + " "
next
see nl

func stoogeSort list, i, j
     if list[j] < list[i]
        temp = list[i]
        list[i] = list[j]
        list[j] = temp ok
     if j - i > 1
        t = (j - i + 1)/3
        stoogeSort(list, i, j-t)
        stoogeSort(list, i+t, j)
        stoogeSort(list, i, j-t) ok
     return list
