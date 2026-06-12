def two_sum(arr, num):
    i = 0
    j = len(arr) - 1
    while i < j:
        if arr[i] + arr[j] == num:
            return (i, j)
        if arr[i] + arr[j] < num:
            i += 1
        else:
            j -= 1
    return None


numbers = [0, 2, 11, 19, 90]
print(two_sum(numbers, 21))
print(two_sum(numbers, 25))
