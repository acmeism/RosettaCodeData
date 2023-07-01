for i in range(1, 101):
    if i**0.5 % 1:
        state='closed'
    else:
        state='open'
    print("Door {}:{}".format(i, state))
