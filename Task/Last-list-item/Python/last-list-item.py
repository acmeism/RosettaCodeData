""" Rosetta code task: Last list item """

def add_least_reduce(lis):
    """ Reduce lis: sum least two elements adding sum to list. Will take len(list) - 1 steps """
    while len(lis) > 1:
        lis.append(lis.pop(lis.index(min(lis))) + lis.pop(lis.index(min(lis))))
        print('Interim list:', lis)
    return lis

LIST = [6, 81, 243, 14, 25, 49, 123, 69, 11]

print(LIST, ' ==> ', add_least_reduce(LIST.copy()))
