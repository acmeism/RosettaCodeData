""" rosettacode.org/wiki/Kirkpatrick–Seidel_algorithm """

import random
from typing import List, Set, Tuple
from dataclasses import dataclass
import math


@dataclass
class Point:
    """ Point class (2D) """
    x: float
    y: float

    def __hash__(self):
        return hash(str(self.x) + ' ' + str(self.y))

    def __eq__(self, other):
        if not isinstance(other, Point):
            return NotImplemented
        return abs(self.x - other.x) < 1e-10 and abs(self.y - other.y) < 1e-10

    def __lt__(self, other):
        if not isinstance(other, Point):
            return NotImplemented
        return self.y < other.y if abs(self.x - other.x) < 1e-10 else self.x < other.x


def flipped(points: List[Point]) -> List[Point]:
    """ flip points to diagonally opposite quadrant """
    return [Point(-p.x, -p.y) for p in points]


def quickselect(ls: List, index: int, lo: int = 0, hi: int = None):
    """ quickselect algoritm for orderable lists """
    if hi is None:
        hi = len(ls) - 1

    if lo == hi:
        return ls[lo]

    pivot = lo + random.randint(0, hi - lo)
    ls[lo], ls[pivot] = ls[pivot], ls[lo]

    cur = lo
    for run in range(lo + 1, hi + 1):
        if ls[run] < ls[lo]:
            cur += 1
            ls[cur], ls[run] = ls[run], ls[cur]

    ls[cur], ls[lo] = ls[lo], ls[cur]

    if index < cur:
        return quickselect(ls, index, lo, cur - 1)
    if index > cur:
        return quickselect(ls, index, cur + 1, hi)
    return ls[cur]


def bridge(points: Set[Point], vertical_line: float) -> Tuple[Point, Point]:
    """ find the upper bridge of the convex hull """
    candidates = set()

    if len(points) == 2:
        pts = list(points)
        return (pts[0], pts[1])

    pairs = []
    modify_s = points.copy()

    while len(modify_s) >= 2:
        p1 = modify_s.pop()
        p2 = modify_s.pop()

        if p1 < p2:
            pairs.append((p1, p2))
        else:
            pairs.append((p2, p1))

    if modify_s:
        candidates.add(modify_s.pop())

    slopes = []
    i = 0
    while i < len(pairs):
        pi, pj = pairs[i]

        if abs(pi.x - pj.x) < 1e-10:
            candidates.add(pi if pi.y > pj.y else pj)
            pairs.pop(i)
        else:
            slopes.append((pi.y - pj.y) / (pi.x - pj.x))
            i += 1

    if not slopes:
        if len(candidates) >= 2:
            c = list(candidates)[:2]
            return (c[0], c[1])
        pts = list(points)[:2]
        return (pts[0], pts[1])

    median_index = (len(slopes) // 2) - (0 if len(slopes) % 2 else 1)
    slopes_copy = slopes.copy()
    median_slope = quickselect(slopes_copy, median_index)

    small = []
    equal = []
    large = []

    for i, slope in enumerate(slopes):
        if slope < median_slope:
            small.append(pairs[i])
        elif abs(slope - median_slope) < 1e-10:
            equal.append(pairs[i])
        else:
            large.append(pairs[i])

    max_slope = -math.inf
    for point in points:
        max_slope = max(max_slope, point.y - median_slope * point.x)

    max_set = [point for point in points if abs(
        point.y - median_slope * point.x - max_slope) < 1e-10]

    left = min(max_set)
    right = max(max_set)

    if left.x <= vertical_line < right.x:
        return (left, right)

    if right.x <= vertical_line:
        for _, p2 in large:
            candidates.add(p2)
        for _, p2 in equal:
            candidates.add(p2)
        for p1, p2 in small:
            candidates.add(p1)
            candidates.add(p2)

    if left.x > vertical_line:
        for p1, _ in small:
            candidates.add(p1)
        for p1, _ in equal:
            candidates.add(p1)
        for p1, p2 in large:
            candidates.add(p1)
            candidates.add(p2)

    return bridge(candidates, vertical_line)


def connect(lower: Point, upper: Point, points: Set[Point]) -> List[Point]:
    """ connect function to build the hull between two points """
    if lower == upper:
        return [lower]

    points_vec = list(points)
    mid_index = len(points_vec) // 2

    max_left = quickselect(points_vec.copy(), mid_index)
    min_right = quickselect(points_vec.copy(), mid_index + 1)

    left, right = bridge(points, (max_left.x + min_right.x) / 2.0)

    points_left = {left}
    points_right = {right}

    for point in points:
        if point.x < left.x:
            points_left.add(point)
        elif point.x > right.x:
            points_right.add(point)

    left_result = connect(lower, left, points_left)
    right_result = connect(right, upper, points_right)

    return left_result + right_result


def upper_hull(points: Set[Point]) -> List[Point]:
    """ compute upper hull """
    points_vec = list(points)
    lower = min(points_vec)

    for point in points:
        if abs(point.x - lower.x) < 1e-10 and point.y > lower.y:
            lower = point

    upper = max(points_vec)

    filtered_points = {lower, upper}
    for pt in points:
        if lower.x < pt.x < upper.x:
            filtered_points.add(pt)

    return connect(lower, upper, filtered_points)


def convex_hull(points: Set[Point]) -> List[Point]:
    """ compute convex hull """
    upper = upper_hull(points)

    flipped_points = {Point(-p.x, -p.y) for p in points}
    flipped_upper = upper_hull(flipped_points)
    lower = flipped(flipped_upper)

    result = upper.copy()

    if result and lower and result[-1] == lower[0]:
        lower = lower[1:]

    if result and lower and result[0] == lower[-1]:
        lower = lower[:-1]

    return result + lower


if __name__ == "__main__":
    # test the Kirkpatrick–Seidel code
    POINTS = [
        Point(0.0, 0.0),
        Point(1.0, 0.0),
        Point(0.0, 1.0),
        Point(0.5, 0.5)
    ]

    print("Input points:")
    for p in POINTS:
        print(f"({p.x}, {p.y})")

    HULL = convex_hull(POINTS)

    print("\nConvex hull points:")
    for p in HULL:
        print(f"({p.x}, {p.y})")
