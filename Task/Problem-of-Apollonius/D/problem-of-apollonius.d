import std.stdio, std.math;

immutable struct Circle { double x, y, r; }
enum Tangent { externally, internally }

/**
Solves the Problem of Apollonius (finding a circle tangent to three
other circles in the plane).

Params:
  c1 = First circle of the problem.
  c2 = Second circle of the problem.
  c3 = Third circle of the problem.
  t1 = How is the solution tangent (externally or internally) to c1.
  t2 = How is the solution tangent (externally or internally) to c2.
  t3 = How is the solution tangent (externally or internally) to c3.

Returns: The Circle that is tangent to c1, c2 and c3.
*/
Circle solveApollonius(in Circle c1, in Circle c2, in Circle c3,
                       in Tangent t1, in Tangent t2, in Tangent t3)
pure nothrow @safe @nogc {
    alias Imd = immutable(double);
    Imd s1 = (t1 == Tangent.externally) ? 1.0 : -1.0;
    Imd s2 = (t2 == Tangent.externally) ? 1.0 : -1.0;
    Imd s3 = (t3 == Tangent.externally) ? 1.0 : -1.0;

    Imd v11 = 2 * c2.x - 2 * c1.x;
    Imd v12 = 2 * c2.y - 2 * c1.y;
    Imd v13 = c1.x ^^ 2 - c2.x ^^ 2 +
              c1.y ^^ 2 - c2.y ^^ 2 -
              c1.r ^^ 2 + c2.r ^^ 2;
    Imd v14 = 2 * s2 * c2.r - 2 * s1 * c1.r;

    Imd v21 = 2 * c3.x - 2 * c2.x;
    Imd v22 = 2 * c3.y - 2 * c2.y;
    Imd v23 = c2.x ^^ 2 - c3.x ^^ 2 +
              c2.y ^^ 2 - c3.y ^^ 2 -
              c2.r ^^ 2 + c3.r ^^ 2;
    Imd v24 = 2 * s3 * c3.r - 2 * s2 * c2.r;

    Imd w12 = v12 / v11;
    Imd w13 = v13 / v11;
    Imd w14 = v14 / v11;

    Imd w22 = v22 / v21 - w12;
    Imd w23 = v23 / v21 - w13;
    Imd w24 = v24 / v21 - w14;

    Imd P = -w23 / w22;
    Imd Q =  w24 / w22;
    Imd M = -w12 * P - w13;
    Imd N =  w14 - w12 * Q;

    Imd a = N * N + Q ^^ 2 - 1;
    Imd b = 2 * M * N - 2 * N * c1.x +
            2 * P * Q - 2 * Q * c1.y +
            2 * s1 * c1.r;
    Imd c = c1.x ^^ 2 + M ^^ 2 - 2 * M * c1.x +
            P ^^ 2 + c1.y ^^ 2 - 2 * P * c1.y - c1.r ^^ 2;

    // find a root of a quadratic equation.
    // This requires the circle centers not to be e.g. colinear
    Imd D = b ^^ 2 - 4 * a * c;
    Imd rs = (-b - D.sqrt) / (2 * a);

    return Circle(M + N * rs, P + Q * rs, rs);
}

void main() {
    immutable c1 = Circle(0.0, 0.0, 1.0);
    immutable c2 = Circle(4.0, 0.0, 1.0);
    immutable c3 = Circle(2.0, 4.0, 2.0);

    alias Te = Tangent.externally;
    solveApollonius(c1, c2, c3, Te, Te, Te).writeln;

    alias Ti = Tangent.internally;
    solveApollonius(c1, c2, c3, Ti, Ti, Ti).writeln;
}
