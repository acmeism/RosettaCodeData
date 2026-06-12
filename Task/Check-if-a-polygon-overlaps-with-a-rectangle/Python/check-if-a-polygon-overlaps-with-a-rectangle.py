#!/usr/bin/python3

class Vector2:
    def __init__(self, x, y):
        self.x = x
        self.y = y

class Projection:
    def __init__(self, min, max):
        self.min = min
        self.max = max

def dot(v1, v2):
    return v1.x * v2.x + v1.y * v2.y

def get_axes(poly):
    axes = []
    for i in range(len(poly)):
        vector1 = poly[i]
        j = 0 if i + 1 == len(poly) else i + 1
        vector2 = poly[j]
        edge = Vector2(vector1.x - vector2.x, vector1.y - vector2.y)
        axes.append(Vector2(-edge.y, edge.x))
    return axes

def project_onto_axis(poly, axis):
    vector = poly[0]
    min = dot(axis, vector)
    max = min
    for i in range(1, len(poly)):
        vector = poly[i]
        p = dot(axis, vector)
        if p < min:
            min = p
        elif p > max:
            max = p
    return Projection(min, max)

def projections_overlap(proj1, proj2):
    return not (proj1.max < proj2.min or proj2.max < proj1.min)

def polygons_overlap(poly1, poly2):
    for axis in get_axes(poly1) + get_axes(poly2):
        proj1 = project_onto_axis(poly1, axis)
        proj2 = project_onto_axis(poly2, axis)
        if not projections_overlap(proj1, proj2):
            return False
    return True

def print_poly(poly):
    print([{'x': p.x, 'y': p.y} for p in poly])

if __name__ == "__main__":
    poly1 = [
        Vector2(0, 0),
        Vector2(0, 2),
        Vector2(1, 4),
        Vector2(2, 2),
        Vector2(2, 0)
    ]
    poly2 = [
        Vector2(4, 0),
        Vector2(4, 2),
        Vector2(5, 4),
        Vector2(6, 2),
        Vector2(6, 0)
    ]
    poly3 = [
        Vector2(1, 0),
        Vector2(1, 2),
        Vector2(5, 4),
        Vector2(9, 2),
        Vector2(9, 0)
    ]
    print('poly1 = ', end='')
    print_poly(poly1)
    print('poly2 = ', end='')
    print_poly(poly2)
    print('poly3 = ', end='')
    print_poly(poly3)
    print()
    print('poly1 and poly2 overlap? ', polygons_overlap(poly1, poly2))
    print('poly1 and poly3 overlap? ', polygons_overlap(poly1, poly3))
    print('poly2 and poly3 overlap? ', polygons_overlap(poly2, poly3))
