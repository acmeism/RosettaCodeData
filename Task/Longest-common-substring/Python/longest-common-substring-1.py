s1 = "thisisatest"
s2 = "testing123testing"
len1, len2 = len(s1), len(s2)
ir, jr = 0, -1
for i1 in range(len1):
    i2 = s2.find(s1[i1])
    while i2 >= 0:
        j1, j2 = i1, i2
        while j1 < len1 and j2 < len2 and s2[j2] == s1[j1]:
            if j1-i1 >= jr-ir:
                ir, jr = i1, j1
            j1 += 1; j2 += 1
        i2 = s2.find(s1[i1], i2+1)
print (s1[ir:jr+1])
