def schwartzian(arr, f):
    return [t[0] for t in sorted([(v, f(v)) for v in arr], key=lambda t: t[1])]


TEST = ["Rosetta", "Code", "is", "a", "programming", "chrestomathy", "site"]

print(TEST, "=>", schwartzian(TEST, len))
