with open('xxx.txt') as f:
    for i, line in enumerate(f):
        if i == 6:
            break
    else:
        print('Not 7 lines in file')
        line = None
