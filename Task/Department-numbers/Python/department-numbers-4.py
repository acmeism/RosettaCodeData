# We start with the Police Department.
# Range is the start, stop, and step. This returns only even numbers.
for p in range(2, 7, 2):
    #Next, the Sanitation Department. A simple range.
    for s in range(1, 7):
        # And now the Fire Department. After determining the Police and Fire
        # numbers we just have to subtract those from 12 to get the FD number.
        f = 12 - p -s
        if s >= f:
            break
        elif f > 7:
            continue
        print("Police: ", p, " Sanitation:", s, " Fire: ", f)
        print("Police: ", p, " Sanitation:", f, " Fire: ", s)
