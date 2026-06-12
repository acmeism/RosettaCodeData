''' rosettacode.org/wiki/Statistics/Chi-squared_distribution#Python '''


from math import exp, pi, sin, sqrt
from matplotlib.pyplot import plot, legend, ylim


def gamma(x):
    ''' gamma function, accurate to about 12 decimal places '''
    p = [0.99999999999980993, 676.5203681218851, -1259.1392167224028,
         771.32342877765313, -176.61502916214059, 12.507343278686905,
         -0.13857109526572012, 9.9843695780195716e-6, 1.5056327351493116e-7]
    if x < 0.5:
        return pi / (sin(pi * x) * gamma(1.0 - x))
    x -= 1.0
    t = p[0]
    for i in range(1, 9):
        t += p[i] / (x + i)

    w = x + 7.5
    return sqrt(2.0 * pi) * w**(x+0.5) * exp(-w) * t


def χ2(x, k):
    ''' Chi-squared function, the probability distribution function (pdf) for chi-squared '''
    return x**(k/2 - 1) * exp(-x/2) / (2**(k/2) * gamma(k / 2)) if x > 0 and k > 0 else 0.0


def gamma_cdf(k, x):
    ''' lower incomplete gamma by series formula with gamma '''
    return x**k * exp(-x) * sum(x**m / gamma(k + m + 1) for m in range(100))


def cdf_χ2(x, k):
    ''' Cumulative probability function (cdf) for chi-squared '''
    return gamma_cdf(k / 2, x / 2) if x > 0 and k > 0 else 0.0


print('x         χ2 k = 1           k = 2           k = 3           k = 4           k = 5')
print('-' * 93)
for x in range(11):
    print(f'{x:2}', end='')
    for k in range(1, 6):
        print(f'{χ2(x, k):16.8}', end='\n' if k % 5 == 0 else '')


print('\nχ2 x     P value (df=3)\n----------------------')
for p in [1, 2, 4, 8, 16, 32]:
    print(f'{p:2}', '    ', 1.0 - cdf_χ2(p, 3))


AIRPORT_DATA = [[77, 23], [88, 12], [79, 21], [81, 19]]

EXPECTED = [[81.25, 18.75],
            [81.25, 18.75],
            [81.25, 18.75],
            [81.25, 18.75]]

DTOTAL = sum((d[pos] - EXPECTED[i][pos])**2 / EXPECTED[i][pos]
             for i, d in enumerate(AIRPORT_DATA) for pos in [0, 1])

print(
    f'\nFor the airport data, diff total is {DTOTAL}, χ2 is {χ2(DTOTAL, 3)}, p value {cdf_χ2(DTOTAL, 3)}')
X = [x * 0.001 for x in range(10000)]
for k in range(5):
    plot(X, [χ2(p, k) for p in X])
legend([0, 1, 2, 3, 4])
ylim(-0.02, 0.5)
