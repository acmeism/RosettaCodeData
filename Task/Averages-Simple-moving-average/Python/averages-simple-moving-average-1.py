from collections import deque

def simplemovingaverage(period):
    assert period == int(period) and period > 0, "Period must be an integer >0"

    summ = n = 0.0
    values = deque([0.0] * period)     # old value queue

    def sma(x):
        nonlocal summ, n

        values.append(x)
        summ += x - values.popleft()
        n = min(n+1, period)
        return summ / n

    return sma
