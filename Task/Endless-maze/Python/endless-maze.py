from random import randrange

xp, yp, na, x, y, e, d, f = 127, 127, 0, [], [], [], -1, randrange(4)

while d != 4:
    a = na
    for n in range(na):
        if x[n] == xp and y[n] == yp:
            a = n
            break

    if a == na:
        na += 1
        x.append(xp)
        y.append(yp)
        for i in range(4):
            e.append(bool(randrange(2)))
        for n in range(na):
            if x[n] == x[a] + 1 and y[n] == y[a]:
                e[4*a] = e[4*n + 2]
            elif x[n] == x[a] and y[n] == y[a] + 1:
                e[4*a + 1] = e[4*n + 3]
            elif x[n] == x[a] - 1 and y[n] == y[a]:
                e[4*a + 2] = e[4*n]
            elif x[n] == x[a] and y[n] == y[a] - 1:
                e[4*a + 3] = e[4*n + 1]

    print("Paths:", end = "")
    paths = [" ahead", " right", " back", " left"]
    for i in range(4):
        if e[4*a + (f + i)%4]:
            print(paths[i], end = "")

    d = -1
    while d < 0:
        entry = input("\n> ")
        match entry:
            case "ahead":
                d = f
            case "right":
                d = (f + 1)%4
            case "back":
                d = (f + 2)%4
            case "left":
                d = (f + 3)%4
            case "exit":
                if xp == 127 and yp == 127:
                    print("You have exited the maze.")
                    d = 4
                else:
                    print("You are not at the exit.")
            case "quit":
                d = 4
            case _:
                print("Entry invalid.")
                continue

    match d:
        case 0:
            if e[4*a]:
                xp += 1
                d = f
            else:
                d = -1
        case 1:
            if e[4*a + 1]:
                yp += 1
                d = f
            else:
                d = -1
        case 2:
            if e[4*a + 2]:
                xp -= 1
                d = f
            else:
                d = -1
        case 3:
            if e[4*a + 3]:
                yp -= 1
                d = f
            else:
                d = -1

    if(d < 0):
        print("No path.")
