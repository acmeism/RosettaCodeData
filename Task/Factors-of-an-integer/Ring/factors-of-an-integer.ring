nArray = list(100)
n = 45
j = 0
for i = 1 to n
    if n % i = 0 j = j + 1 nArray[j] = i ok
next

see "Factors of " + n + " = "
for i = 1 to j
    see "" + nArray[i] + " "
next
