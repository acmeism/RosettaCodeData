from __future__ import division
from math import sqrt
from itertools import count
from pprint import pprint as pp
try:
    from itertools import izip as zip
except:
    pass

# Remove duplicates and sort, largest first.
circles = sorted(set([
   #  xcenter       ycenter      radius
   (1.6417233788,  1.6121789534, 0.0848270516),
  (-1.4944608174,  1.2077959613, 1.1039549836),
   (0.6110294452, -0.6907087527, 0.9089162485),
   (0.3844862411,  0.2923344616, 0.2375743054),
  (-0.2495892950, -0.3832854473, 1.0845181219),
   (1.7813504266,  1.6178237031, 0.8162655711),
  (-0.1985249206, -0.8343333301, 0.0538864941),
  (-1.7011985145, -0.1263820964, 0.4776976918),
  (-0.4319462812,  1.4104420482, 0.7886291537),
   (0.2178372997, -0.9499557344, 0.0357871187),
  (-0.6294854565, -1.3078893852, 0.7653357688),
   (1.7952608455,  0.6281269104, 0.2727652452),
   (1.4168575317,  1.0683357171, 1.1016025378),
   (1.4637371396,  0.9463877418, 1.1846214562),
  (-0.5263668798,  1.7315156631, 1.4428514068),
  (-1.2197352481,  0.9144146579, 1.0727263474),
  (-0.1389358881,  0.1092805780, 0.7350208828),
   (1.5293954595,  0.0030278255, 1.2472867347),
  (-0.5258728625,  1.3782633069, 1.3495508831),
  (-0.1403562064,  0.2437382535, 1.3804956588),
   (0.8055826339, -0.0482092025, 0.3327165165),
  (-0.6311979224,  0.7184578971, 0.2491045282),
   (1.4685857879, -0.8347049536, 1.3670667538),
  (-0.6855727502,  1.6465021616, 1.0593087096),
   (0.0152957411,  0.0638919221, 0.9771215985),
   ]), key=lambda x: -x[-1])

def vdcgen(base=2):
    'Van der Corput sequence generator'
    for n in count():
        vdc, denom = 0,1
        while n:
            denom *= base
            n, remainder = divmod(n, base)
            vdc += remainder / denom
        yield vdc

def vdc_2d():
    'Two dimensional Van der Corput sequence generator'
    for x, y in zip(vdcgen(base=2), vdcgen(base=3)):
        yield x, y

def bounding_box(circles):
    'Return minx, maxx, miny, maxy'
    return (min(x - r for x,y,r in circles),
            max(x + r for x,y,r in circles),
            min(y - r for x,y,r in circles),
            max(y + r for x,y,r in circles)
           )
def circle_is_in_circle(c1, c2):
    x1, y1, r1 = c1
    x2, y2, r2 = c2
    return sqrt((x2 - x1)**2 + (y2 - y1)**2) <= r1 - r2

def remove_covered_circles(circles):
    'Takes circles in decreasing radius order. Removes those covered by others'
    covered = []
    for i, c1 in enumerate(circles):
        eliminate = [c2 for c2 in circles[i+1:]
                        if circle_is_in_circle(c1, c2)]
        if eliminate: covered += [c1, eliminate]
        for c in eliminate: circles.remove(c)
    #pp(covered)

def main(circles):
    print('Originally %i circles' % len(circles))
    print('Bounding box: %r' % (bounding_box(circles),))
    remove_covered_circles(circles)
    print('  down to %i  due to some being wholly covered by others' % len(circles))
    minx, maxx, miny, maxy = bounding_box(circles)
    # Shift to 0,0 and compute r**2 once
    circles2 = [(x - minx, y - miny, r*r) for x, y, r in circles]
    scalex, scaley = abs(maxx - minx), abs(maxy - miny)
    pcount, inside, last = 0, 0, ''
    for px, py in vdc_2d():
        pcount += 1
        px *= scalex; py *= scaley
        if any((px-cx)**2 + (py-cy)**2 <= cr2 for cx, cy, cr2 in circles2):
            inside += 1
        if not pcount % 100000:
            area = (inside/pcount) * scalex * scaley
            print('Points: %8i, Area estimate: %r'
                  % (pcount, area))
            # Hack to check if precision OK
            this = '%.4f' % area
            if this == last:
                break
            else:
                last = this
    print('The value has settled to %s' % this)


if __name__ == '__main__':
    main(circles)
