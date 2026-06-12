import numpy as np
import scipy as sp
import scipy.stats

def welch_ttest(x1, x2):
    n1 = x1.size
    n2 = x2.size
    m1 = np.mean(x1)
    m2 = np.mean(x2)
    v1 = np.var(x1, ddof=1)
    v2 = np.var(x2, ddof=1)
    t = (m1 - m2) / np.sqrt(v1 / n1 + v2 / n2)
    df = (v1 / n1 + v2 / n2)**2 / (v1**2 / (n1**2 * (n1 - 1)) + v2**2 / (n2**2 * (n2 - 1)))
    p = 2 * sp.stats.t.cdf(-abs(t), df)
    return t, df, p

welch_ttest(np.array([3.0, 4.0, 1.0, 2.1]), np.array([490.2, 340.0, 433.9]))
(-9.559497721932658, 2.0008523488562844, 0.01075156114978449)
