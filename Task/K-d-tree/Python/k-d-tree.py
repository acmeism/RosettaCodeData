from random import seed, random
from time import clock
from operator import itemgetter
from collections import namedtuple
from math import sqrt
from copy import deepcopy


def sqd(p1, p2):
    return sum((c1 - c2) ** 2 for c1, c2 in zip(p1, p2))


class KdNode(object):
    __slots__ = ("dom_elt", "split", "left", "right")

    def __init__(self, dom_elt, split, left, right):
        self.dom_elt = dom_elt
        self.split = split
        self.left = left
        self.right = right


class Orthotope(object):
    __slots__ = ("min", "max")

    def __init__(self, mi, ma):
        self.min, self.max = mi, ma


class KdTree(object):
    __slots__ = ("n", "bounds")

    def __init__(self, pts, bounds):
        def nk2(split, exset):
            if not exset:
                return None
            exset.sort(key=itemgetter(split))
            m = len(exset) // 2
            d = exset[m]
            while m + 1 < len(exset) and exset[m + 1][split] == d[split]:
                m += 1
            d = exset[m]


            s2 = (split + 1) % len(d)  # cycle coordinates
            return KdNode(d, split, nk2(s2, exset[:m]),
                                    nk2(s2, exset[m + 1:]))
        self.n = nk2(0, pts)
        self.bounds = bounds

T3 = namedtuple("T3", "nearest dist_sqd nodes_visited")


def find_nearest(k, t, p):
    def nn(kd, target, hr, max_dist_sqd):
        if kd is None:
            return T3([0.0] * k, float("inf"), 0)

        nodes_visited = 1
        s = kd.split
        pivot = kd.dom_elt
        left_hr = deepcopy(hr)
        right_hr = deepcopy(hr)
        left_hr.max[s] = pivot[s]
        right_hr.min[s] = pivot[s]

        if target[s] <= pivot[s]:
            nearer_kd, nearer_hr = kd.left, left_hr
            further_kd, further_hr = kd.right, right_hr
        else:
            nearer_kd, nearer_hr = kd.right, right_hr
            further_kd, further_hr = kd.left, left_hr

        n1 = nn(nearer_kd, target, nearer_hr, max_dist_sqd)
        nearest = n1.nearest
        dist_sqd = n1.dist_sqd
        nodes_visited += n1.nodes_visited

        if dist_sqd < max_dist_sqd:
            max_dist_sqd = dist_sqd
        d = (pivot[s] - target[s]) ** 2
        if d > max_dist_sqd:
            return T3(nearest, dist_sqd, nodes_visited)
        d = sqd(pivot, target)
        if d < dist_sqd:
            nearest = pivot
            dist_sqd = d
            max_dist_sqd = dist_sqd

        n2 = nn(further_kd, target, further_hr, max_dist_sqd)
        nodes_visited += n2.nodes_visited
        if n2.dist_sqd < dist_sqd:
            nearest = n2.nearest
            dist_sqd = n2.dist_sqd

        return T3(nearest, dist_sqd, nodes_visited)

    return nn(t.n, p, t.bounds, float("inf"))


def show_nearest(k, heading, kd, p):
    print(heading + ":")
    print("Point:           ", p)
    n = find_nearest(k, kd, p)
    print("Nearest neighbor:", n.nearest)
    print("Distance:        ", sqrt(n.dist_sqd))
    print("Nodes visited:   ", n.nodes_visited, "\n")


def random_point(k):
    return [random() for _ in range(k)]


def random_points(k, n):
    return [random_point(k) for _ in range(n)]

if __name__ == "__main__":
    seed(1)
    P = lambda *coords: list(coords)
    kd1 = KdTree([P(2, 3), P(5, 4), P(9, 6), P(4, 7), P(8, 1), P(7, 2)],
                  Orthotope(P(0, 0), P(10, 10)))
    show_nearest(2, "Wikipedia example data", kd1, P(9, 2))

    N = 400000
    t0 = clock()
    kd2 = KdTree(random_points(3, N), Orthotope(P(0, 0, 0), P(1, 1, 1)))
    t1 = clock()
    text = lambda *parts: "".join(map(str, parts))
    show_nearest(2, text("k-d tree with ", N,
                         " random 3D points (generation time: ",
                         t1-t0, "s)"),
                 kd2, random_point(3))
