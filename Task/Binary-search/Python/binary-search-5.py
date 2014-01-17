def binary_search(l, value):
    low = 0
    high = len(l)-1
    while low + 1 < high:
        mid = (low+high)//2
        if l[mid] > value:
            high = mid
        elif l[mid] < value:
            low = mid
        else:
            return mid
    return high if abs(l[high] - value) < abs(l[low] - value) else low
