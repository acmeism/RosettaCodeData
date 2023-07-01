// The control points of a planar quadratic Bézier curve form a
// triangle--called the "control polygon"--that completely contains
// the curve. Furthermore, the rectangle formed by the minimum and
// maximum x and y values of the control polygon completely contain
// the polygon, and therefore also the curve.
//
// Thus a simple method for narrowing down where intersections might
// be is: subdivide both curves until you find "small enough" regions
// where these rectangles overlap.

import std.algorithm;
import std.container.slist;
import std.math;
import std.range;
import std.stdio;

struct point
{
  double x, y;
}

struct quadratic_spline         // Non-parametric spline.
{
  double c0, c1, c2;
}

struct quadratic_curve          // Planar parametric spline.
{
  quadratic_spline x, y;
}

void
subdivide_quadratic_spline (quadratic_spline q, double t,
                            ref quadratic_spline u,
                            ref quadratic_spline v)
{
  // Subdivision by de Casteljau's algorithm.
  immutable s = 1 - t;
  immutable c0 = q.c0;
  immutable c1 = q.c1;
  immutable c2 = q.c2;
  u.c0 = c0;
  v.c2 = c2;
  u.c1 = (s * c0) + (t * c1);
  v.c1 = (s * c1) + (t * c2);
  u.c2 = (s * u.c1) + (t * v.c1);
  v.c0 = u.c2;
}

void
subdivide_quadratic_curve (quadratic_curve q, double t,
                            ref quadratic_curve u,
                            ref quadratic_curve v)
{
  subdivide_quadratic_spline (q.x, t, u.x, v.x);
  subdivide_quadratic_spline (q.y, t, u.y, v.y);
}

bool
rectangles_overlap (double xa0, double ya0, double xa1, double ya1,
                    double xb0, double yb0, double xb1, double yb1)
{
  // It is assumed that xa0<=xa1, ya0<=ya1, xb0<=xb1, and yb0<=yb1.
  return (xb0 <= xa1 && xa0 <= xb1 && yb0 <= ya1 && ya0 <= yb1);
}

void
test_intersection (quadratic_curve p, quadratic_curve q, double tol,
                   ref bool exclude, ref bool accept,
                   ref point intersection)
{
  // I will not do a lot of checking for intersections, as one might
  // wish to do in a particular application. If the boxes are small
  // enough, I will accept the point as an intersection.

  immutable pxmin = min (p.x.c0, p.x.c1, p.x.c2);
  immutable pymin = min (p.y.c0, p.y.c1, p.y.c2);
  immutable pxmax = max (p.x.c0, p.x.c1, p.x.c2);
  immutable pymax = max (p.y.c0, p.y.c1, p.y.c2);

  immutable qxmin = min (q.x.c0, q.x.c1, q.x.c2);
  immutable qymin = min (q.y.c0, q.y.c1, q.y.c2);
  immutable qxmax = max (q.x.c0, q.x.c1, q.x.c2);
  immutable qymax = max (q.y.c0, q.y.c1, q.y.c2);

  exclude = true;
  accept = false;
  if (rectangles_overlap (pxmin, pymin, pxmax, pymax,
                          qxmin, qymin, qxmax, qymax))
    {
      exclude = false;
      immutable xmin = max (pxmin, qxmin);
      immutable xmax = min (pxmax, qxmax);
      assert (xmax >= xmin);
      if (xmax - xmin <= tol)
        {
          immutable ymin = max (pymin, qymin);
          immutable ymax = min (pymax, qymax);
          assert (ymax >= ymin);
          if (ymax - ymin <= tol)
            {
              accept = true;
              intersection = point ((0.5 * xmin) + (0.5 * xmax),
                                    (0.5 * ymin) + (0.5 * ymax));
            }
        }
    }
}

bool
seems_to_be_a_duplicate (point[] intersections, point xy,
                         double spacing)
{
  bool seems_to_be_dup = false;
  int i = 0;
  while (!seems_to_be_dup && i != intersections.length)
    {
      immutable pt = intersections[i];
      seems_to_be_dup =
        fabs (pt.x - xy.x) < spacing && fabs (pt.y - xy.y) < spacing;
      i += 1;
    }
  return seems_to_be_dup;
}

point[]
find_intersections (quadratic_curve p, quadratic_curve q,
                    double tol, double spacing)
{
  point[] intersections;
  int num_intersections = 0;

  struct workset
  {
    quadratic_curve p, q;
  }
  SList!workset workload;

  // Initial workload.
  workload.insertFront(workset (p, q));

  // Quit looking after having /*found four intersections*/ or emptied
  // the workload.
  while (/*num_intersections != 4 &&*/ !workload.empty)
    {
      auto work = workload.front;
      workload.removeFront();

      bool exclude;
      bool accept;
      point intersection;
      test_intersection (work.p, work.q, tol, exclude, accept,
                         intersection);
      if (accept)
        {
          // This is a crude way to avoid detecting the same
          // intersection twice: require some space between
          // intersections. For, say, font design work, this method
          // should be adequate.
          if (!seems_to_be_a_duplicate (intersections,
                                        intersection, spacing))
            {
              intersections.length = num_intersections + 1;
              intersections[num_intersections] = intersection;
              num_intersections += 1;
            }
        }
      else if (!exclude)
        {
          quadratic_curve p0, p1, q0, q1;
          subdivide_quadratic_curve (work.p, 0.5, p0, p1);
          subdivide_quadratic_curve (work.q, 0.5, q0, q1);
          workload.insertFront(workset (p0, q0));
          workload.insertFront(workset (p0, q1));
          workload.insertFront(workset (p1, q0));
          workload.insertFront(workset (p1, q1));
        }
    }

  return intersections;
}

int
main ()
{
  quadratic_curve p, q;
  p.x.c0 = -1.0;  p.x.c1 =  0.0;  p.x.c2 =  1.0;
  p.y.c0 =  0.0;  p.y.c1 = 10.0;  p.y.c2 =  0.0;
  q.x.c0 =  2.0;  q.x.c1 = -8.0;  q.x.c2 =  2.0;
  q.y.c0 =  1.0;  q.y.c1 =  2.0;  q.y.c2 =  3.0;

  immutable tol = 0.0000001;
  immutable spacing = 10 * tol;

  auto intersections = find_intersections (p, q, tol, spacing);
  for (int i = 0; i != intersections.length; i += 1)
    printf("(%f, %f)\n", intersections[i].x, intersections[i].y);

  return 0;
}
