def monkey_coconuts(sailors=5):
    "Parameterised the number of sailors using an inner loop including the last mornings case"
    nuts = sailors
    while True:
        n0, wakes = nuts, []
        for sailor in range(sailors + 1):
            portion, remainder = divmod(n0, sailors)
            wakes.append((n0, portion, remainder))
            if portion <= 0 or remainder != (1 if sailor != sailors else 0):
                nuts += 1
                break
            n0 = n0 - portion - remainder
        else:
            break
    return nuts, wakes

if __name__ == "__main__":
    for sailors in [5, 6]:
        nuts, wake_stats = monkey_coconuts(sailors)
        print("\nFor %i sailors the initial nut count is %i" % (sailors, nuts))
        print("On each waking, the nut count, portion taken, and monkeys share are:\n ",
              ',\n  '.join(repr(ws) for ws in wake_stats))
