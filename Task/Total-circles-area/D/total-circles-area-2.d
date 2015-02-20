import std.stdio, std.typecons, std.math, std.algorithm, std.range;

struct Vec { double x, y; }

alias VF = double function(in Vec, in Vec) pure nothrow @safe @nogc;
enum VF vCross = (v1, v2) => v1.x * v2.y - v1.y * v2.x;
enum VF vDot   = (v1, v2) => v1.x * v2.x + v1.y * v2.y;

alias VV = Vec function(in Vec, in Vec) pure nothrow @safe @nogc;
enum VV vAdd = (v1, v2) => Vec(v1.x + v2.x, v1.y + v2.y);
enum VV vSub = (v1, v2) => Vec(v1.x - v2.x, v1.y - v2.y);

enum vLen = (in Vec v) pure nothrow @safe @nogc => vDot(v, v).sqrt;
enum VF vDist = (a, b) => vSub(a, b).vLen;
enum vScale = (in double s, in Vec v) pure nothrow @safe @nogc =>
    Vec(v.x * s, v.y * s);
enum vNorm = (in Vec v) pure nothrow @safe @nogc =>
    Vec(v.x / v.vLen, v.y / v.vLen);

alias A = Typedef!double;

enum vAngle = (in Vec v) pure nothrow @safe @nogc => atan2(v.y, v.x).A;

A aNorm(in A a) pure nothrow @safe @nogc {
    if (a > PI)  return A(a - PI * 2.0);
    if (a < -PI) return A(a + PI * 2.0);
    return              a;
}

struct Circle { double x, y, r; }

A[] circleCross(in Circle c0, in Circle c1) pure nothrow {
    immutable d = vDist(Vec(c0.x, c0.y), Vec(c1.x, c1.y));
    if (d >= c0.r + c1.r || d <= abs(c0.r - c1.r))
        return [];

    immutable s = (c0.r + c1.r + d) / 2.0;
    immutable a = sqrt(s * (s - d) * (s - c0.r) * (s - c1.r));
    immutable h = 2.0 * a / d;
    immutable dr = Vec(c1.x - c0.x, c1.y - c0.y);
    immutable dx = vScale(sqrt(c0.r ^^ 2 - h ^^ 2), dr.vNorm);
    immutable ang = (c0.r ^^ 2 + d ^^ 2 > c1.r ^^ 2) ?
                    dr.vAngle :
                    A(PI + dr.vAngle);
    immutable da = asin(h / c0.r).A;
    return [A(ang - da), A(ang + da)].map!aNorm.array;
}

// Angles of the start and end points of the circle arc.
alias Angle2 = Tuple!(A,"a0", A,"a1");

alias Arc = Tuple!(Circle,"c", Angle2,"aa");

enum arcPoint = (in Circle c, in A a) pure nothrow @safe @nogc =>
    vAdd(Vec(c.x, c.y), Vec(c.r * cos(cast(double)a),
                            c.r * sin(cast(double)a)));

alias ArcF = Vec function(in Arc) pure nothrow @safe @nogc;
enum ArcF arcStart  = ar => arcPoint(ar.c, ar.aa.a0);
enum ArcF arcMid    = ar => arcPoint(ar.c, A((ar.aa.a0+ar.aa.a1) / 2));
enum ArcF arcEnd    = ar => arcPoint(ar.c, ar.aa.a1);
enum ArcF arcCenter = ar => Vec(ar.c.x, ar.c.y);

enum arcArea = (in Arc ar) pure nothrow @safe @nogc =>
    ar.c.r ^^ 2 * (ar.aa.a1 - ar.aa.a0) / 2.0;

Arc[] splitCircles(immutable Circle[] cs) pure /*nothrow*/ {
    static enum cSplit = (in Circle c, in A[] angs) pure nothrow =>
        c.repeat.zip(angs.zip(angs.dropOne).map!Angle2).map!Arc;

    // If an arc that was part of one circle is inside *another* circle,
    // it will not be part of the zero-winding path, so reject it.
    static bool inCircle(VC)(in VC vc, in Circle c) pure nothrow @nogc{
        return vc[1] != c && vDist(Vec(vc[0].x, vc[0].y),
                                   Vec(c.x, c.y)) < c.r;
    }

    enum inAnyCircle = (in Arc arc) nothrow @safe =>
        cs.map!(c => inCircle(tuple(arc.arcMid, arc.c), c)).any;

    auto f(in Circle c) pure nothrow {
        auto angs = cs.map!(c1 => circleCross(c, c1)).join;
        return tuple(c, ([A(-PI), A(PI)] ~ angs)
                        .sort().release);
    }

    return cs.map!f.map!(ca => cSplit(ca[])).join
           .filter!(ar => !inAnyCircle(ar)).array;
}


/** Given a list of arcs, build sets of closed paths from them. If
one arc's end point is no more than 1e-4 from another's start point,
they are considered connected.  Since these start/end points resulted
from intersecting circles earlier, they *should* be exactly the same,
but floating point precision may cause small differences, hence the
1e-4 error margin.  When there are genuinely different intersections
closer than this margin, the method will backfire, badly. */
const(Arc[])[] makePaths(in Arc[] arcs) pure nothrow @safe {
    static const(Arc[])[] joinArcs(in Arc[] a, in Arc[] xxs)
    pure nothrow {
        static enum eps = 1e-4;
        if (xxs.empty) return [a];
        immutable x = xxs[0];
        const xs = xxs.dropOne;
        if (a.empty) return joinArcs([x], xs);
        if (vDist(a[0].arcStart, a.back.arcEnd) < eps)
            return [a] ~ joinArcs([], xxs);
        if (vDist(a.back.arcEnd, x.arcStart) < eps)
            return joinArcs(a ~ [x], xs);
        return joinArcs(a, xs ~ [x]);
    }
    return joinArcs([], arcs);
}

// Slice N-polygon into N-2 triangles.
double polylineArea(in Vec[] vvs) pure nothrow {
    static enum triArea = (in Vec a, in Vec b, in Vec c)
        pure nothrow @nogc => vCross(vSub(b, a), vSub(c, b)) / 2.0;
    const vs = vvs.dropOne;
    immutable vvs0 = vvs[0];
    return zip(vs, vs.dropOne).map!(vv => triArea(vvs0, vv[])).sum;
}

double pathArea(in Arc[] arcs) pure nothrow {
    static f(in Tuple!(double, const(Vec)[]) ae, in Arc arc)
    pure nothrow {
        return tuple(ae[0] + arc.arcArea,
                     ae[1] ~ [arc.arcCenter, arc.arcEnd]);
    }
    const ae = reduce!f(tuple(0.0, (const(Vec)[]).init), arcs);
    return ae[0] + ae[1].polylineArea;
}

enum circlesArea = (immutable Circle[] cs) pure /*nothrow*/ =>
    cs.splitCircles.makePaths.map!pathArea.sum;


void main() {
    immutable circles = [
        Circle( 1.6417233788,  1.6121789534, 0.0848270516),
        Circle(-1.4944608174,  1.2077959613, 1.1039549836),
        Circle( 0.6110294452, -0.6907087527, 0.9089162485),
        Circle( 0.3844862411,  0.2923344616, 0.2375743054),
        Circle(-0.2495892950, -0.3832854473, 1.0845181219),
        Circle( 1.7813504266,  1.6178237031, 0.8162655711),
        Circle(-0.1985249206, -0.8343333301, 0.0538864941),
        Circle(-1.7011985145, -0.1263820964, 0.4776976918),
        Circle(-0.4319462812,  1.4104420482, 0.7886291537),
        Circle( 0.2178372997, -0.9499557344, 0.0357871187),
        Circle(-0.6294854565, -1.3078893852, 0.7653357688),
        Circle( 1.7952608455,  0.6281269104, 0.2727652452),
        Circle( 1.4168575317,  1.0683357171, 1.1016025378),
        Circle( 1.4637371396,  0.9463877418, 1.1846214562),
        Circle(-0.5263668798,  1.7315156631, 1.4428514068),
        Circle(-1.2197352481,  0.9144146579, 1.0727263474),
        Circle(-0.1389358881,  0.1092805780, 0.7350208828),
        Circle( 1.5293954595,  0.0030278255, 1.2472867347),
        Circle(-0.5258728625,  1.3782633069, 1.3495508831),
        Circle(-0.1403562064,  0.2437382535, 1.3804956588),
        Circle( 0.8055826339, -0.0482092025, 0.3327165165),
        Circle(-0.6311979224,  0.7184578971, 0.2491045282),
        Circle( 1.4685857879, -0.8347049536, 1.3670667538),
        Circle(-0.6855727502,  1.6465021616, 1.0593087096),
        Circle( 0.0152957411,  0.0638919221, 0.9771215985)];

    writefln("Area: %1.13f", circles.circlesArea);
}
