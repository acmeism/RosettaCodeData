from math import nan, isnan
from numpy import arange


def aitken(f, p0):
    """ Aitken's extrapolation """
    p1 = f(p0)
    p2 = f(p1)
    return p0 - (p1 - p0)**2 / (p2 - 2 * p1 + p0)

def steffensen_aitken(f, pinit, tol, maxiter):
    """ Steffensen's method using Aitken """
    p0 = pinit
    p = aitken(f, p0)
    iter = 1
    while abs(p - p0) > tol and iter < maxiter:
        p0 = p
        p = aitken(f, p0)
        iter += 1
    return nan if abs(p - p0) > tol else p

def deCasteljau(c0, c1, c2, t):
    """ deCasteljau function """
    s = 1.0 - t
    return s * (s * c0 + t * c1) + t * (s * c1 + t * c2)

def xConvexLeftParabola(t): return deCasteljau(2, -8, 2, t)
def yConvexRightParabola(t): return deCasteljau(1, 2, 3, t)
def implicit_equation(x, y): return 5 * x**2 + y - 5

def f(t):
    """ Outside of NumPy arithmetic may return NoneType on overflow """
    if type(t) == type(None):
        return nan
    return implicit_equation(xConvexLeftParabola(t), yConvexRightParabola(t)) + t

def test_steffensen(tol=0.00000001, iters=1000, stepsize=0.1):
    """ test the example """
    for t0 in arange(0, 1.1, stepsize):
        print(f't0 = {t0:0.1f} : ', end='')
        t = steffensen_aitken(f, t0, tol, iters)
        if isnan(t):
            print('no answer')
        else:
            x = xConvexLeftParabola(t)
            y = yConvexRightParabola(t)
            if abs(implicit_equation(x, y)) <= tol:
                print(f'intersection at ({x}, {y})')
            else:
                print('spurious solution')
    return 0


if __name__ == '__main__':

    test_steffensen()
