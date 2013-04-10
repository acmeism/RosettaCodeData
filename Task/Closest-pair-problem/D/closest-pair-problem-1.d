import std.stdio, std.typecons, std.math, std.algorithm,
       std.array, std.random, std.traits;

auto bruteForceClosestPair(T)(in T[] points) pure nothrow {
  auto minD = Unqual!(typeof(T.re)).infinity;
  Unqual!T minI, minJ;
  foreach (i, p1; points[0 .. $-1])
    foreach (j, p2; points[i+1 .. $]) {
      immutable dist = abs(p1 - p2);
      if (dist < minD) {
        minD = dist;
        minI = p1;
        minJ = p2;
      }
    }
  return tuple(minD, minI, minJ);
}

auto closestPair(T)(T[] points) /*pure nothrow*/ {
  static Tuple!(typeof(T.re),T,T) inner(in T[] xP, /*in*/ T[] yP) {
    if (xP.length <= 3)
      return bruteForceClosestPair(xP);
    const Pl = xP[0 .. xP.length/2];
    const Pr = xP[xP.length/2 .. $];
    immutable xDiv = Pl[$ - 1].re;
    auto Yr = partition!(p => p.re <= xDiv)(yP);
    immutable dl_pairl = inner(Pl, yP[0 .. yP.length - Yr.length]);
    immutable dr_pairr = inner(Pr, Yr);
    immutable dm_pairm= dl_pairl[0]<dr_pairr[0] ? dl_pairl : dr_pairr;
    immutable dm = dm_pairm[0];
    const nextY= yP.filter!(p => abs(p.re - xDiv) < dm)().array();
    if (nextY.length > 1) {
      auto minD = typeof(T.re).infinity;
      size_t minI, minJ;
      foreach (i; 0 .. nextY.length-1)
        foreach (j; i+1 .. min(i+8, nextY.length)) {
          immutable double dist = abs(nextY[i] - nextY[j]);
          if (dist < minD) {
            minD = dist;
            minI = i;
            minJ = j;
          }
        }
      return dm <= minD ? dm_pairm :
        Tuple!(typeof(T.re),T,T)(minD,nextY[minI],nextY[minJ]);
    } else
      return dm_pairm;
  }

  sort!q{ a.re < b.re }(points);
  auto xP = points.dup;
  sort!q{ a.im < b.im }(points);
  return inner(xP, points);
}

void main() {
  auto pts= [5+9i, 9+3i, 2, 8+4i, 7+4i, 9+10i, 1+9i, 8+2i, 10i, 9+6i];
  writeln(pts);
  writeln("bruteForceClosestPair: ", bruteForceClosestPair(pts));
  writeln("          closestPair: ", closestPair(pts));

  auto rnd = Random(1); // set seed
  cdouble[10_000] points;
  foreach (ref p; points)
    p = uniform(0.0, 1000.0, rnd) + uniform(0.0, 1000.0, rnd) * 1i;
  writeln("bruteForceClosestPair: ", bruteForceClosestPair(points));
  writeln("          closestPair: ", closestPair(points));
}
