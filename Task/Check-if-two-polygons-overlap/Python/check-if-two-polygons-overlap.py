# overlaying_polygons.py by xing216
from math import inf
class Vector2:
    def __init__(self, x: float, y: float) -> None:
        self.x = x
        self.y = y
    def dot(self, other: 'Vector2') -> float:
        return self.x * other.x + self.y * other.y
    def __repr__(self) -> str:
        return f'({self.x}, {self.y})'
class Projection:
    min: float
    max: float
    def overlaps(self, proj2: 'Projection') -> bool:
        if self.max < proj2.min or proj2.max < self.min: return False
        return True
class Polygon:
    def __init__(self, vertices: list[tuple[float, float]]) -> None:
        self.vertices = [Vector2(*vertex) for vertex in vertices]
        self.axes = self.get_axes()
    def get_axes(self) -> list[Vector2]:
        axes = []
        for i, vertex1 in enumerate(self.vertices):
            if i + 1 == len(self.vertices): vertex2 = self.vertices[0]
            else: vertex2 = self.vertices[i + 1]
            edge = (vertex1.x - vertex2.x, vertex1.y - vertex2.y)
            axes.append(Vector2(-edge[1], edge[0]))
        return axes
    def projection_on_axis(self, axis: Vector2) -> Projection:
        projection = Projection()
        projection.min = inf
        projection.max = -inf
        for vertex in self.vertices:
            p = axis.dot(vertex)
            if p < projection.min:
                projection.min = p
            if p > projection.max:
                projection.max = p
        return projection
    def overlaps(self, other: 'Polygon') -> bool:
        for axes in [self.axes, other.axes]:
            for axis in axes:
                proj1 = self.projection_on_axis(axis)
                proj2 = other.projection_on_axis(axis)
                if not proj1.overlaps(proj2): return False
        return True

poly1 = Polygon([(0.0, 0.0), (0.0, 2.0), (1.0, 4.0), (2.0, 2.0), (2.0, 0.0)])
poly2 = Polygon([(4.0, 0.0), (4.0, 2.0), (5.0, 4.0), (6.0, 2.0), (6.0, 0.0)])
poly3 = Polygon([(1.0, 0.0), (1.0, 2.0), (5.0, 4.0), (9.0, 2.0), (9.0, 0.0)])
polygons = (poly1, poly2, poly3)
for i, polygon in enumerate(polygons):
    print(f'poly{i+1} = {polygon.vertices}')
print(f'poly1 and poly2 overlap? {polygons[0].overlaps(polygons[1])}')
print(f'poly1 and poly3 overlap? {polygons[0].overlaps(polygons[2])}')
print(f'poly2 and poly3 overlap? {polygons[1].overlaps(polygons[2])}')
