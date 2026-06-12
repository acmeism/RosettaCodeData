import random as r

def GenerateRandomSet(n: int) -> list:
    set_ = list(range(1, n+1))
    r.shuffle(set_)
    return set_
