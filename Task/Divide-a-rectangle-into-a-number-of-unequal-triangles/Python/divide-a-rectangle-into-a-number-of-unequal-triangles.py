import random
from typing import List, Union, Tuple


# Types
Num = Union[int, float]
Point = Tuple[Num, Num]


#%% Algorithms.
def rect_into_tri(
        top_right: Tuple[Num, Num] = (2, 1), # assuming bottom_left is at 0,0
        triangles: int             = 5,      # Odd number > 2
        _rand_tol: Num             = 1e6,    # Sets max random divisions of rectange width
        ) -> List[Tuple[Point, Point, Point]]:
    """
    Divide Rectangle into triangles number of non-similar triangles that
    exactly cover the rectangles area.

    Parameters
    ----------
    top_right : Tuple[Num, Num], optional
        Rectangle bottom-left is always at (0, 0). The default is (2, 1).
    triangles : int, optional
        Number of triangles created. An odd number > 2. The default is 5.
    _rand_tol : Num, optional
        Sets max random divisions of rectange width. The default is 1e6.

    Returns
    -------
    List[Tuple[Point, Point, Point]]
        A list of triangles; each of three points - of two numbers.



    Algorithm "Divide into top and bottom triangles"
    ================================================

    Think of a rectangle lying, without rotation, on a plane. Lets name the corners A, B, C, and D like this:

        A        B

        D        C

    Add one point, `p` between-but-not-equal-to A and B giving

        A p      B

        D        C

    Create the two extra lines D-p and p-C creating 3 triangles A-p-D, D-p-C and p-B-C.
    Now if distances A-p, p-B and B-C are all different, then the triangles will be different.

    If we instead inserted **two** points between A-B, p0 and p1, we can insert **one** point q0, along D-C

          0  1
        A p  p   B

        D   q    C
            0

    We think of the L-to-R ordered top points as A p0 p1 then B; and the ordered l-to-R bottom points as D q0 then C.
    * Create the triangles by using the i'th, (i+1)'th top points and the i'th bottom point; alternating with
      the (i)'th (i+1)'th bottom point and the (i+1)'th top point.
    * Ensure the distances between successive top points, B-C, and successive bottom points are all different to get different triangles.
    * If you insert `n`top points p, then you need `n-1` bottom points q.

    Randomly divide A-B n times, and D-C n-1 times; then redo this if all the distances aren't different to your required precision.

    This algorithm generates many triangles with a side along D-C as well as A-B

    """

    width, height = top_right
    assert triangles > 2 and triangles % 2 == 1, "Needs Odd number greater than 2"
    #assert triangles * 100 < _rand_tol, "Might not have enough tolerance to ensure disimilar triangles"

    _rand_tol = int(_rand_tol)

    #%% Point insertion
    insert_top = triangles // 2
    p = q = None
    while not p or not different_distances(p, q, height):
        p = [0] + rand_points(insert_top,     width, int(_rand_tol)) + [width]  # top points
        q = [0] + rand_points(insert_top - 1, width, int(_rand_tol)) + [width]  # bottom points

    #%% Triangle extraction
    top_tri = [((t0, height), (t1, height), (b0, 0))
               for t0, t1, b0 in zip(p, p[1:], q)]
    bottom_tri = [((b0, 0), (b1, 0), (t1, height))
                  for b0, b1, t1 in zip(q, q[1:], p[1:])]

    return top_tri + bottom_tri

def rect_into_top_tri(
        top_right: Tuple[Num, Num] = (2, 1),
        triangles: int             = 4,
        _rand_tol: Num             = 1e6,
        ) -> List[Tuple[Point, Point, Point]]:
    """
    Divide Rectangle into triangles number of non-similar triangles that
    exactly cover the rectangles area.

    Parameters
    ----------
    top_right : Tuple[Num, Num], optional
        Rectangle bottom-left is always at (0, 0). The default is (2, 1).
    triangles : int, optional
        Number of triangles created. An odd number > 2. The default is 4.
    _rand_tol : Num, optional
        Sets max random divisions of rectange width. The default is 1e6.

    Returns
    -------
    List[Tuple[Point, Point, Point]]
        A list of triangles; each of three points - of two numbers.



    Algorithm "Divide along top into triangles"
    ===========================================

    Think of a rectangle lying, without rotation, on a plane. Lets name the corners A, B, C, and D like this:

        A        B

        D        C

    If we add The diagonal D-B we split into two triangles BUT they are similar.

    Add one point, `p` between-but-not-equal-to A and B giving

        A p      B

        D        C

    Create the one extra line D-p creating 3 triangles D-A-p, D-p-B and D-B-C.
    Now if distances A-p, and p-B are all different, then the triangles will
    not be similar.

    If we instead inserted **two** points between A-B, p0 and p1, we get:

          0  1
        A p  p   B

        D        C


    We think of the L-to-R ordered top points as A p0 p1 then B lets call those
    the top points top[0] = A, top[i+1] = p[i], top[-1] = B;
    * Create the triangles by using the i'th, (i+1)'th top points and bottom point D.
    * Add the Triangle D-B-C

    This algorithm generates only one triangle with a side along D-C

    """

    width, height = top_right
    assert int(triangles)==triangles and triangles > 2, "Needs int > 2"
    #assert triangles * 100 < _rand_tol, "Might not have enough tolerance to ensure disimilar triangles"

    _rand_tol = int(_rand_tol)

    #%% Point insertion
    insert_top = triangles - 2
    top = [0] + rand_points(insert_top, width, int(_rand_tol)) + [width]  # top points

    #%% Triangle extraction
    top_tri = [((0, 0), (t0, height), (t1, height))
               for t0, t1 in zip(top, top[1:])]
    bottom_tri = [((0, 0), (width, height), (width, 0))]

    return top_tri + bottom_tri

#%% Helpers
def rand_points(n: int, width: Num=1, _rand_tol: int=1_000_000) -> List[float]:
    "return n sorted, random points where 0 < point < width"
    return sorted(p * width / _rand_tol
                  for p in random.sample(range(1, _rand_tol), n))

def different_distances(p: List[Num], q: List[Num], height: Num) -> bool:
    "Are all point-to-next-point distances in p and q; and height all different?"
    diffs =  [p1 - p0 for p0, p1 in zip(p, p[1:])]
    diffs += [q1 - q0 for q0, q1 in zip(q, q[1:])]
    diffs += [height]
    return len(diffs) == len(set(diffs))


#%% Main.
if __name__ == "__main__":
    from pprint import pprint as pp

    print("\nrect_into_tri #1")
    pp(rect_into_tri((2, 1), 5, 10))
    print("\nrect_into_tri #2")
    pp(rect_into_tri((2, 1), 5, 10))
    print("\nrect_into_top_tri #1")
    pp(rect_into_top_tri((2, 1), 4, 10))
    print("\nrect_into_top_tri #2")
    pp(rect_into_top_tri((2, 1), 4, 10))
