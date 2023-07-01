>>> def area_by_shoelace(x, y):
    "Assumes x,y points go around the polygon in one direction"
    return abs( sum(i * j for i, j in zip(x,             y[1:] + y[:1]))
               -sum(i * j for i, j in zip(x[1:] + x[:1], y            ))) / 2

>>> points = [(3,4), (5,11), (12,8), (9,5), (5,6)]
>>> x, y = zip(*points)
>>> area_by_shoelace(x, y)
30.0
>>>
