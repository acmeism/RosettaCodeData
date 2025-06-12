actions = {
    0: lambda i: print(i),
    1: lambda i: print("fizz"),
    2: lambda i: print("buzz"),
    3: lambda i: print("fizzbuzz"),
}

for i in range(1, 101):
    action_index = 0

    if i % 3 == 0:
        action_index += 1

    if i % 5 == 0:
        action_index += 2

    actions[action_index](i)
