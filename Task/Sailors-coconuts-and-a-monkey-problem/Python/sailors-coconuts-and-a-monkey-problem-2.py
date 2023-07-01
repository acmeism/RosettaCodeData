def wake_and_split(n0, sailors, depth=None):
    if depth is None:
        depth = sailors
    portion, remainder = divmod(n0, sailors)
    if portion <= 0 or remainder != (1 if depth else 0):
        return None
    else:
        return n0 if not depth else wake_and_split(n0 - portion - remainder, sailors, depth - 1)


def monkey_coconuts(sailors=5):
    "Parameterised the number of sailors using recursion including the last mornings case"
    nuts = sailors
    while True:
        if wake_and_split(n0=nuts, sailors=sailors) is None:
            nuts += 1
        else:
            break
    return nuts

if __name__ == "__main__":
    for sailors in [5, 6]:
        nuts = monkey_coconuts(sailors)
        print("For %i sailors the initial nut count is %i" % (sailors, nuts))
