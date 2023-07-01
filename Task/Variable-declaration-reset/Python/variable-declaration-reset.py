s = [1, 2, 2, 3, 4, 4, 5]

for i in range(len(s)):
    curr = s[i]
    if i > 0 and curr == prev:
        print(i)
    prev = curr
