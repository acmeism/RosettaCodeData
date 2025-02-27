from itertools import chain

def A000032():
    '''Non finite sequence of Lucas numbers.
    '''
    return unfoldr(recurrence, [0, 1])

def n_step_fibonacci(n):
    '''Non-finite series of N-step Fibonacci numbers,
       defined by a recurrence relation.
    '''
    return unfoldr(
        recurrence,
        chain(
            (0,),
            (2 ** i for i in range(0, n-1))))

def recurrence(xs):
    '''Recurrence relation in Fibonacci and related series.
    '''
    h, *t = xs
    return h, t + [sum(xs)]

def unfoldr(f, residue):
    '''Generic anamorphism.
       A lazy (generator) list unfolded from a seed value by
       repeated application of f until no residue remains.
       Dual to fold/reduce.
       f returns either None, or just (value, residue).
       For a strict output value, wrap in list().
    '''
    while residue is not None:
        value, residue = f(residue)
        yield value
