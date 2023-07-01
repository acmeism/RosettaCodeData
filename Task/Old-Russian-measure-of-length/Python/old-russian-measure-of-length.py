from sys import argv

unit2mult = {"arshin": 0.7112, "centimeter": 0.01,     "diuym":   0.0254,
             "fut":    0.3048, "kilometer":  1000.0,   "liniya":  0.00254,
             "meter":  1.0,    "milia":      7467.6,   "piad":    0.1778,
             "sazhen": 2.1336, "tochka":     0.000254, "vershok": 0.04445,
             "versta": 1066.8}

if __name__ == '__main__':
    assert len(argv) == 3, 'ERROR. Need two arguments - number then units'
    try:
        value = float(argv[1])
    except:
        print('ERROR. First argument must be a (float) number')
        raise
    unit = argv[2]
    assert unit in unit2mult, ( 'ERROR. Only know the following units: '
                                + ' '.join(unit2mult.keys()) )

    print("%g %s to:" % (value, unit))
    for unt, mlt in sorted(unit2mult.items()):
        print('  %10s: %g' % (unt, value * unit2mult[unit] / mlt))
