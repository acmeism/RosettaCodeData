# Search for an odd factor of a using brute force:
for i in range(n):
    if (n%2) == 0:
        continue
    if (n%i) == 0:
        result = i
        break
else:
    result = None
    print "No odd factors found"
