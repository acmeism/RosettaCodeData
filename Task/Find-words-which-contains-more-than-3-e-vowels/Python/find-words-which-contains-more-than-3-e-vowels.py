with open('unixdict.txt', 'rt') as f:
    for line in f.readlines():
        if not any(c in 'aiou' for c in line) and sum(c=='e' for c in line)>3:
            print(line.strip())
