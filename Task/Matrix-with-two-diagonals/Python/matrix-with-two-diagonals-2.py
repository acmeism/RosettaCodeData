import numpy as np

def diagdiag(n):
    """
    Create a diagonal-diagonal matrix

    Args:
        n (int): number of rows.

    Returns:
        a (numpy matrix): double diagonal matrix.
    """
    d = np.eye(n)
    a = d + np.fliplr(d)
    if n % 2:
        k = (n - 1) // 2
        a[k, k] = 1
    return a

print(diagdiag(7))
