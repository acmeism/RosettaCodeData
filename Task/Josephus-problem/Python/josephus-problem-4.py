from itertools import compress, cycle
def josephus(prisoner, kill, surviver):
    p = range(prisoner)
    k = [0] * kill
    k[kill-1] = 1
    s = [1] * kill
    s[kill -1] = 0
    queue = p

    queue = compress(queue, cycle(s))
    try:
        while True:
            p.append(queue.next())
    except StopIteration:
        pass

    kil=[]
    killed = compress(p, cycle(k))
    try:
        while True:
            kil.append(killed.next())
    except StopIteration:
        pass

    print 'The surviver is: ', kil[-surviver:]
    print 'The kill sequence is ', kil[:prisoner-surviver]

josephus(41,3,2)
The surviver is:  [15, 30]
The kill sequence is  [2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 0, 4, 9, 13, 18, 22, 27, 31, 36, 40, 6, 12, 19, 25, 33, 39, 7, 16, 28, 37, 10, 24, 1, 21, 3, 34]
josephus(5,2,1)
The surviver is:  [2]
The kill sequence is  [1, 3, 0, 4]
