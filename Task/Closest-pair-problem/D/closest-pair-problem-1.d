import std.stdio, std.typecons, std.math, std.algorithm,
       std.random, std.traits, std.range, std.complex;

//auto bfClosestPair(T)(in T[] points) pure nothrow {
//  return pairwise(points.length.iota, points.length.iota)
//         .reduce!(min!((i, j) => abs(points[i] - points[j])));
//}

auto bruteForceClosestPair(T)(in T[] points) pure nothrow {
  auto minD = Unqual!(typeof(T.re)).infinity;
  T minI, minJ;
  foreach (immutable i, const p1; points.dropBackOne)
    foreach (const p2; points[i + 1 .. $]) {
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
  static Tuple!(typeof(T.re), T, T) inner(in T[] xP, /*in*/ T[] yP)
  pure nothrow {
    if (xP.length <= 3)
      return xP.bruteForceClosestPair;
    const Pl = xP[0 .. $ / 2];
    const Pr = xP[$ / 2 .. $];
    immutable xDiv = Pl.back.re;
    auto Yr = yP.partition!(p => p.re <= xDiv);
    immutable dl_pairl = inner(Pl, yP[0 .. yP.length - Yr.length]);
    immutable dr_pairr = inner(Pr, Yr);
    immutable dm_pairm = dl_pairl[0]<dr_pairr[0] ? dl_pairl : dr_pairr;
    immutable dm = dm_pairm[0];
    const nextY = yP.filter!(p => abs(p.re - xDiv) < dm).array;

    if (nextY.length > 1) {
      auto minD = typeof(T.re).infinity;
      size_t minI, minJ;
      foreach (immutable i; 0 .. nextY.length - 1)
        foreach (immutable j; i + 1 .. min(i + 8, nextY.length)) {
          immutable double dist = abs(nextY[i] - nextY[j]);
          if (dist < minD) {
            minD = dist;
            minI = i;
            minJ = j;
          }
        }
      return dm <= minD ? dm_pairm :
                        typeof(return)(minD, nextY[minI], nextY[minJ]);
    } else
      return dm_pairm;
  }

  points.sort!q{ a.re < b.re };
  const xP = points.dup;
  points.sort!q{ a.im < b.im };
  return inner(xP, points);
}

void main() {
  alias C = complex;
  auto pts = [C(5,9), C(9,3), C(2), C(8,4), C(7,4), C(9,10), C(1,9),
              C(8,2), C(0,10), C(9,6)];
  pts.writeln;
  writeln("bruteForceClosestPair: ", pts.bruteForceClosestPair);
  writeln("          closestPair: ", pts.closestPair);

  rndGen.seed = 1;
  Complex!double[10_000] points;
  foreach (ref p; points)
    p = C(uniform(0.0, 1000.0) + uniform(0.0, 1000.0));
  writeln("bruteForceClosestPair: ", points.bruteForceClosestPair);
  writeln("          closestPair: ", points.closestPair);
}
