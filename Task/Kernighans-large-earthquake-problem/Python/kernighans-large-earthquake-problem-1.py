python -c '
with open("data.txt") as f:
    for ln in f:
        if float(ln.strip().split()[2]) > 6:
            print(ln.strip())'
