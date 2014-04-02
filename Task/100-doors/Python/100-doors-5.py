for i in range(1, 101):
    if i**0.5 % 1:
        state='open'
    else:
        state='close'
    print("Door {}:{}".format(i, state))
