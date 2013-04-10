import core.stdc.stdio, core.stdc.stdlib, std.math; // for Phobos
//import tango.stdc.stdio, tango.stdc.stdlib, tango.math.Math;

int bfClosestPair2(cdouble[] points, out size_t i1, out size_t i2) {
  auto minD = typeof(points[0].re).infinity;
  if (points.length < 2) {
    i1 = i2 = size_t.max;
    return -1;
  }
  size_t minI, minJ;
  for (int i = 0; i < points.length-1; i++) {
    auto points_i_re = points[i].re;
    auto points_i_im = points[i].im;
    for (int j = i+1; j < points.length; j++) {
      auto dre = points_i_re - points[j].re;
      auto dist = dre * dre;
      if (dist < minD) {
        auto dim = points_i_im - points[j].im;
        dist += dim * dim;
        if (dist < minD) {
          minD = dist;
          minI = i;
          minJ = j;
        }
      }
    }
  }

  i1 = minI;
  i2 = minJ;
  return 0;
}

void main() {
    srand(31415);
    auto pts = new cdouble[10_000];
    foreach (ref p; pts)
        p = 1000.0 *  (cast(double)rand() / (RAND_MAX + 1.0)) +
            1000.0i * (cast(double)rand() / (RAND_MAX + 1.0));

    size_t i, j;
    int err = bfClosestPair2(pts, i, j);
    if (err < 0)
        return;
    double d = sqrt((pts[i].re - pts[j].re) * (pts[i].re - pts[j].re) +
                    (pts[i].im - pts[j].im) * (pts[i].im - pts[j].im));
    printf("Closest pair: dist: %lf  p1, p2: (%lf, %lf), (%lf, %lf)\n",
           d, pts[i].re, pts[i].im, pts[j].re, pts[j].im);
}
