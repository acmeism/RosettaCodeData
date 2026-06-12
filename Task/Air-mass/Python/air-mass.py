""" Rosetta Code task: Air_mass """

from math import sqrt, cos, exp

DEG = 0.017453292519943295769236907684886127134  # degrees to radians
RE = 6371000                                     # Earth radius in meters
dd = 0.001      # integrate in this fraction of the distance already covered
FIN = 10000000  # integrate only to a height of 10000km, effectively infinity

def rho(a):
    """ the density of air as a function of height above sea level """
    return exp(-a / 8500.0)

def height(a, z, d):
    """
    a = altitude of observer
    z = zenith angle (in degrees)
    d = distance along line of sight
    """
    return sqrt((RE + a)**2 + d**2 - 2 * d * (RE + a) * cos((180 - z) * DEG)) - RE

def column_density(a, z):
    """ integrates density along the line of sight """
    dsum, d = 0.0, 0.0
    while d < FIN:
        delta = max(dd, (dd)*d)  # adaptive step size to avoid it taking forever:
        dsum += rho(height(a, z, d + 0.5 * delta)) * delta
        d += delta
    return dsum

def airmass(a, z):
    return column_density(a, z) / column_density(a, 0)

print('Angle           0 m          13700 m\n', '-' * 36)
for z in range(0, 91, 5):
    print(f"{z: 3d}      {airmass(0, z): 12.7f}    {airmass(13700, z): 12.7f}")
