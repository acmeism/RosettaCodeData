# berger_table.py by Xing216
def scheduler(competitors):
    if competitors & 1:
        competitors += 1
    last = competitors
    half = competitors // 2
    rounds = last - 1
    tables = [list() for i in range(rounds)]
    for i in range(1, last):
        row = i - 1
        tables[row] = [list() * half]
        tables[row][0] = [0, 0]
        if i & 1:
            tables[row][0][1] = last
            opponent = (i + 1) // 2
            tables[row][0][0] = opponent
        else:
            tables[row][0][0] = last
            opponent = half + i // 2
            tables[row][0][1] = opponent
        for _ in range(1, half):
            next_opponent = opponent + 1 if opponent < last - 1 else 1
            tables[row].append([next_opponent, 0])
            opponent = next_opponent
    last_guest = 1
    for i in reversed(range(1, last)):
        row = i - 1
        for j in reversed(range(0, half)):
            opponent = last_guest
            if j > 0:
                tables[row][j][1] = opponent
                last_guest = opponent + 1 if opponent < last - 1 else 1
    return tables
def print_table(table):
    for i, round in enumerate(table):
        print(f"Round {(i + 1):2}", end=": ")
        for match in round:
            print(f"{match[0]:2}-{match[1]:<2}", end=" ")
        print()
print_table(scheduler(12))
