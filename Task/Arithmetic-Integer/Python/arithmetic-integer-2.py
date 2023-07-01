def getnum(prompt):
    while True: # retrying ...
        try:
            n = int(raw_input(prompt))
        except ValueError:
            print "Input could not be parsed as an integer. Please try again."\
            continue
        break
    return n

x = getnum("Number1: ")
y = getnum("Number2: ")
...
