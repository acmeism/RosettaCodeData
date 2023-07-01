def digroot(n):
    while n > 9:
        n = sum([int(d) for d in str(n)])
    return n

with open('unixdict.txt') as f:
    lines = [w.strip() for w in f.readlines()]
    words = [w for w in lines if len(w) >= 4 and all(c in 'abcdef' for c in w)]
    results = [[w, int(w, 16)] for w in words]
    for a in results:
        a.append(digroot(a[1]))

    print(f"Hex words in unixdict.txt:\nRoot  Word      Base 10\n", "-"*22)
    for a in sorted(results, key=lambda x:x[2]):
        print(f"{a[2]}     {a[0]:6}{a[1]:10}")

    print("Total count of these words:", len(results))
    print("\nHex words with > 3 distinct letters:\nRoot  Word      Base 10\n", "-"*22)
    results = [a for a in results if len(set(str(a[0]))) > 3]
    for a in sorted(results, key=lambda x:x[2]):
        print(f"{a[2]}     {a[0]:6}{a[1]:10}")

    print("Total count of those words:", len(results))
