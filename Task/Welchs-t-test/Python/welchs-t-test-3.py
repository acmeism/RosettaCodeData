import math

def welch_ttest(a1, a2):
    n1 = len(a1)
    n2 = len(a2)
    if n1 <= 1 or n2 <= 1:
        raise ValueError

    mean1 = sum(a1) / n1
    mean2 = sum(a2) / n2

    var1 = sum((x - mean1)**2 for x in a1) / (n1 - 1)
    var2 = sum((x - mean2)**2 for x in a2) / (n2 - 1)

    t = (mean1 - mean2) / math.sqrt(var1 / n1 + var2 / n2)
    df = (var1 / n1 + var2 / n2)**2 / (var1**2 / (n1**2 * (n1 - 1)) + var2**2 / (n2**2 * (n2 - 1)))
    p = betain(df / (t**2 + df), df / 2, 1 / 2)

    return t, df, p
