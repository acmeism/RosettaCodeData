// If you are using GCC, compile with -std=gnu2x because there may be
// C23-isms: [[attributes]], empty () instead of (void), etc.

/* In this program, both of the curves are adaptively "flattened":
   that is, converted to a piecewise linear approximation. Then the
   problem is reduced to finding intersections of line segments.

   How efficient or inefficient the method is I will not try to
   answer. (And I do sometimes compute things "too often", although a
   really good optimizer might fix that.)

   I will use the symmetric power basis that was introduced by
   J. Sánchez-Reyes:

     J. Sánchez-Reyes, ‘The symmetric analogue of the polynomial power
         basis’, ACM Transactions on Graphics, vol 16 no 3, July 1997,
         page 319.

     J. Sánchez-Reyes, ‘Applications of the polynomial s-power basis
         in geometry processing’, ACM Transactions on Graphics, vol 19
         no 1, January 2000, page 35.

   Flattening a quadratic that is represented in this basis has a few
   advantages, which I will not go into here. */

#include <stdio.h>
#include <stdbool.h>
#include <math.h>

static inline void
do_nothing ()
{
}

struct bernstein_spline
{
  double b0;
  double b1;
  double b2;
};

struct spower_spline
{
  double c0;
  double c1;
  double c2;
};

typedef struct bernstein_spline bernstein_spline;
typedef struct spower_spline spower_spline;

struct spower_curve
{
  spower_spline x;
  spower_spline y;
};

typedef struct spower_curve spower_curve;

// Convert a non-parametric spline from Bernstein basis to s-power.
[[gnu::const]] spower_spline
bernstein_spline_to_spower (bernstein_spline S)
{
  spower_spline T =
    {
      .c0 = S.b0,
      .c1 = (2 * S.b1) - S.b0 - S.b2,
      .c2 = S.b2
    };
  return T;
}

// Compose (c0, c1, c2) with (t0, t1). This will map the portion
// [t0,t1] onto [0,1]. (To get these expressions, I did not use the
// general-degree methods described by Sánchez-Reyes, but instead used
// Maxima, some while ago.)
//
// This method is an alternative to de Casteljau subdivision, and can
// be done with the coefficients in any basis. Instead of breaking the
// spline into two pieces at a parameter value t, it gives you the
// portion lying between two parameter values. In general that
// requires two applications of de Casteljau subdivision. On the other
// hand, subdivision requires two applications of the following.
[[gnu::const]] inline spower_spline
spower_spline_portion (spower_spline S, double t0, double t1)
{
  double t0_t0 = t0 * t0;
  double t0_t1 = t0 * t1;
  double t1_t1 = t1 * t1;
  double c2p1m0 = S.c2 + S.c1 - S.c0;

  spower_spline T =
    {
      .c0 = S.c0 + (c2p1m0 * t0) - (S.c1 * t0_t0),
      .c1 = (S.c1 * t1_t1) - (2 * S.c1 * t0_t1) + (S.c1 * t0_t0),
      .c2 = S.c0 + (c2p1m0 * t1) - (S.c1 * t1_t1)
    };
  return T;
}

[[gnu::const]] inline spower_curve
spower_curve_portion (spower_curve C, double t0, double t1)
{
  spower_curve D =
    {
      .x = spower_spline_portion (C.x, t0, t1),
      .y = spower_spline_portion (C.y, t0, t1)
    };
  return D;
}

// Given a parametric curve, is it "flat enough" to have its quadratic
// terms removed?
[[gnu::const]] inline bool
flat_enough (spower_curve C, double tol)
{
  // The degree-2 s-power polynomials are 1-t, t(1-t), t. We want to
  // remove the terms in t(1-t). The maximum of t(1-t) is 1/4, reached
  // at t=1/2. That accounts for the 1/8=0.125 in the following:
  double cx0 = C.x.c0;
  double cx1 = C.x.c1;
  double cx2 = C.x.c2;
  double cy0 = C.y.c0;
  double cy1 = C.y.c1;
  double cy2 = C.y.c2;
  double dx = cx2 - cx0;
  double dy = cy2 - cy0;
  double error_squared = 0.125 * ((cx1 * cx1) + (cy1 * cy1));
  double length_squared = (dx * dx) + (dy * dy);
  return (error_squared <= length_squared * tol * tol);
}

// Given two line segments, do they intersect? One solution to this
// problem is to use the implicitization method employed in the Maxima
// example, except to do it with linear instead of quadratic
// curves. That is what I do here, with the the roles of who gets
// implicitized alternated. If both ways you get as answer a parameter
// in [0,1], then the segments intersect.
void
test_line_segment_intersection (double ax0, double ax1,
                                double ay0, double ay1,
                                double bx0, double bx1,
                                double by0, double by1,
                                bool *they_intersect,
                                double *x, double *y)
{
  double anumer = ((bx1 - bx0) * ay0 - (by1 - by0) * ax0
                   + bx0 * by1 - bx1 * by0);
  double bnumer = -((ax1 - ax0) * by0 - (ay1 - ay0) * bx0
                    + ax0 * ay1 - ax1 * ay0);
  double denom = ((ax1 - ax0) * (by1 - by0)
                  - (ay1 - ay0) * (bx1 - bx0));
  double ta = anumer / denom;   /* Parameter of segment a. */
  double tb = bnumer / denom;   /* Parameter of segment b. */
  *they_intersect = (0 <= ta && ta <= 1 && 0 <= tb && tb <= 1);
  if (*they_intersect)
    {
      *x = ((1 - ta) * ax0) + (ta * ax1);
      *y = ((1 - ta) * ay0) + (ta * ay1);
    }
}

bool
too_close (double x, double y, double xs[], double ys[],
           size_t num_points, double spacing)
{
  bool too_close = false;
  size_t i = 0;
  while (!too_close && i != num_points)
    {
      too_close = (fabs (x - xs[i]) < spacing
                   && fabs (y - ys[i]) < spacing);
      i += 1;
    }
  return too_close;
}

void
recursion (double tp0, double tp1, double tq0, double tq1,
           spower_curve P, spower_curve Q,
           double tol, double spacing, size_t max_points,
           double xs[max_points], double ys[max_points],
           size_t *num_points)
{
  if (*num_points == max_points)
    do_nothing ();
  else if (!flat_enough (spower_curve_portion (P, tp0, tp1), tol))
    {
      double tp_half = (0.5 * tp0) + (0.5 * tp1);
      if (!(flat_enough (spower_curve_portion (Q, tq0, tq1), tol)))
        {
          double tq_half = (0.5 * tq0) + (0.5 * tq1);
          recursion (tp0, tp_half, tq0, tq_half, P, Q, tol,
                     spacing, max_points, xs, ys, num_points);
          recursion (tp0, tp_half, tq_half, tq1, P, Q, tol,
                     spacing, max_points, xs, ys, num_points);
          recursion (tp_half, tp1, tq0, tq_half, P, Q, tol,
                     spacing, max_points, xs, ys, num_points);
          recursion (tp_half, tp1, tq_half, tq1, P, Q, tol,
                     spacing, max_points, xs, ys, num_points);
        }
      else
        {
          recursion (tp0, tp_half, tq0, tq1, P, Q, tol,
                     spacing, max_points, xs, ys, num_points);
          recursion (tp_half, tp1, tq0, tq1, P, Q, tol,
                     spacing, max_points, xs, ys, num_points);
        }
    }
  else if (!(flat_enough (spower_curve_portion (Q, tq0, tq1), tol)))
    {
      double tq_half = (0.5 * tq0) + (0.5 * tq1);
      recursion (tp0, tp1, tq0, tq_half, P, Q, tol,
                 spacing, max_points, xs, ys, num_points);
      recursion (tp0, tp1, tq_half, tq1, P, Q, tol,
                 spacing, max_points, xs, ys, num_points);
    }
  else
    {
      spower_curve P1 = spower_curve_portion (P, tp0, tp1);
      spower_curve Q1 = spower_curve_portion (Q, tq0, tq1);
      bool they_intersect;
      double x, y;
      test_line_segment_intersection (P1.x.c0, P1.x.c2,
                                      P1.y.c0, P1.y.c2,
                                      Q1.x.c0, Q1.x.c2,
                                      Q1.y.c0, Q1.y.c2,
                                      &they_intersect, &x, &y);
      if (they_intersect &&
          !too_close (x, y, xs, ys, *num_points, spacing))
        {
          xs[*num_points] = x;
          ys[*num_points] = y;
          *num_points += 1;
        }
    }
}

void
find_intersections (spower_curve P, spower_curve Q,
                    double flatness_tolerance,
                    double point_spacing,
                    size_t max_points,
                    double xs[max_points],
                    double ys[max_points],
                    size_t *num_points)
{
  *num_points = 0;
  recursion (0, 1, 0, 1, P, Q, flatness_tolerance, point_spacing,
             max_points, xs, ys, num_points);
}

int
main ()
{
  bernstein_spline bPx = { .b0 = -1, .b1 =  0, .b2 =  1 };
  bernstein_spline bPy = { .b0 =  0, .b1 = 10, .b2 =  0 };
  bernstein_spline bQx = { .b0 =  2, .b1 = -8, .b2 =  2 };
  bernstein_spline bQy = { .b0 =  1, .b1 =  2, .b2 =  3 };

  spower_spline Px = bernstein_spline_to_spower (bPx);
  spower_spline Py = bernstein_spline_to_spower (bPy);
  spower_spline Qx = bernstein_spline_to_spower (bQx);
  spower_spline Qy = bernstein_spline_to_spower (bQy);

  spower_curve P = { .x = Px, .y = Py };
  spower_curve Q = { .x = Qx, .y = Qy };

  double flatness_tolerance = 0.001;
  double point_spacing = 0.000001; /* Max norm minimum spacing. */

  const size_t max_points = 10;
  double xs[max_points];
  double ys[max_points];
  size_t num_points;

  find_intersections (P, Q, flatness_tolerance, point_spacing,
                      max_points, xs, ys, &num_points);

  for (size_t i = 0; i != num_points; i += 1)
    printf ("(%f, %f)\n", xs[i], ys[i]);

  return 0;
}
