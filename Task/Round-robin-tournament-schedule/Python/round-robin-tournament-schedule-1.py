# round_robin.py by Xing216
from copy import deepcopy
def shift_up(myList):
    myLen = len(myList)
    return [myList[i % myLen] for i in range(1, 1 + myLen)]
def scheduler(competitors):
    """Uses the original method by Richard Schurig"""
    if competitors % 2 == 1:
        n = competitors + 1
        horizontal_rows = n - 1
    else:
        n = competitors
        horizontal_rows = n
    vertical_rows = n // 2
    table = [[[] for _ in range(vertical_rows)] for _ in range(horizontal_rows)]
    competitor = 1
    for i, row in enumerate(table):
        for col in table[i]:
            if competitor == competitors:
                col.append(competitor)
                competitor = 1
            else:
                col.append(competitor)
                competitor += 1
    table2 = deepcopy(table)
    table2 = shift_up(table2)
    for row in table2: row.reverse()
    for i, row in enumerate(table):
        for j, col in enumerate(table[i]):
            col.append(table2[i][j][0])
    return table
def print_table(table):
    for i, round in enumerate(table):
        print(f"Round {(i + 1):2}", end=": ")
        for match in round:
            print(f"{match[0]:2}-{match[1]:<2}", end=" ")
        print()
print_table(scheduler(12))
