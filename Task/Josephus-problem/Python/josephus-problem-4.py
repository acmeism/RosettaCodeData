from itertools import compress, cycle
def josephus(prisoner, kill, survivor):
    p = list(range(prisoner))
    k = [0] * kill
    k[kill-1] = 1
    s = [1] * kill
    s[kill -1] = 0
    queue = p

    queue = compress(queue, cycle(s))
    try:
        while True:
            p.append(next(queue))
    except StopIteration:
        pass

    kil=[]
    killed = compress(p, cycle(k))
    try:
        while True:
            kil.append(next(killed))
    except StopIteration:
        pass

    print('The survivor is: ', kil[-survivor:])
    print('The kill sequence is ', kil[:prisoner-survivor])

josephus(41, 3, 2)

josephus(5, 2, 1)
