from __future__ import annotations
import math
from functools import lru_cache
from typing import NamedTuple

CACHE_SIZE = None


def hypotenuse(leg: float,
               other_leg: float) -> float:
    """Returns hypotenuse for given legs"""
    return math.sqrt(leg ** 2 + other_leg ** 2)


class Vector(NamedTuple):
    slope: float
    length: float

    @property
    @lru_cache(CACHE_SIZE)
    def angle(self) -> float:
        return math.atan(self.slope)

    @property
    @lru_cache(CACHE_SIZE)
    def x(self) -> float:
        return self.length * math.sin(self.angle)

    @property
    @lru_cache(CACHE_SIZE)
    def y(self) -> float:
        return self.length * math.cos(self.angle)

    def __add__(self, other: Vector) -> Vector:
        """Returns self + other"""
        new_x = self.x + other.x
        new_y = self.y + other.y
        new_length = hypotenuse(new_x, new_y)
        new_slope = new_y / new_x
        return Vector(new_slope, new_length)

    def __neg__(self) -> Vector:
        """Returns -self"""
        return Vector(self.slope, -self.length)

    def __sub__(self, other: Vector) -> Vector:
        """Returns self - other"""
        return self + (-other)

    def __mul__(self, scalar: float) -> Vector:
        """Returns self * scalar"""
        return Vector(self.slope, self.length * scalar)

    def __truediv__(self, scalar: float) -> Vector:
        """Returns self / scalar"""
        return self * (1 / scalar)


if __name__ == '__main__':
    v1 = Vector(1, 1)

    print("Pretty print:")
    print(v1, end='\n' * 2)

    print("Addition:")
    v2 = v1 + v1
    print(v1 + v1, end='\n' * 2)

    print("Subtraction:")
    print(v2 - v1, end='\n' * 2)

    print("Multiplication:")
    print(v1 * 2, end='\n' * 2)

    print("Division:")
    print(v2 / 2)
