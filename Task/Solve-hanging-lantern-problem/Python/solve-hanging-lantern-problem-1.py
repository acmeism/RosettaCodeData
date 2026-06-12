def getLantern(arr):
    res = 0
    for i in range(0, n):
        if arr[i] != 0:
            arr[i] -= 1
            res += getLantern(arr)
            arr[i] += 1
    if res == 0:
        res = 1
    return res

a = []
n = int(input())
for i in range(0, n):
    a.append(int(input()))
print(getLantern(a))
