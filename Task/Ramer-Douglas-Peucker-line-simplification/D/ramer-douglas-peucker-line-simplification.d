import std.algorithm;
import std.exception : enforce;
import std.math;
import std.stdio;

void main() {
    creal[] pointList = [
        0.0 +  0.0i,
        1.0 +  0.1i,
        2.0 + -0.1i,
        3.0 +  5.0i,
        4.0 +  6.0i,
        5.0 +  7.0i,
        6.0 +  8.1i,
        7.0 +  9.0i,
        8.0 +  9.0i,
        9.0 +  9.0i
    ];
    creal[] pointListOut;

    ramerDouglasPeucker(pointList, 1.0, pointListOut);

    writeln("result");
    for (size_t i=0; i< pointListOut.length; i++) {
        writeln(pointListOut[i].re, ",", pointListOut[i].im);
    }
}

real perpendicularDistance(const creal pt, const creal lineStart, const creal lineEnd) {
    creal d = lineEnd - lineStart;

    //Normalise
    real mag =  hypot(d.re, d.im);
    if (mag > 0.0) {
        d /= mag;
    }

    creal pv = pt - lineStart;

    //Get dot product (project pv onto normalized direction)
    real pvdot = d.re * pv.re + d.im * pv.im;

    //Scale line direction vector
    creal ds = pvdot * d;

    //Subtract this from pv
    creal a = pv - ds;

    return hypot(a.re, a.im);
}

void ramerDouglasPeucker(const creal[] pointList, real epsilon, ref creal[] output) {
    enforce(pointList.length >= 2, "Not enough points to simplify");

    // Find the point with the maximum distance from line between start and end
    real dmax = 0.0;
    size_t index = 0;
    size_t end = pointList.length-1;
    for (size_t i=1; i<end; i++) {
        real d = perpendicularDistance(pointList[i], pointList[0], pointList[end]);
        if (d > dmax) {
            index = i;
            dmax = d;
        }
    }

    // If max distance is greater than epsilon, recursively simplify
    if (dmax > epsilon) {
        // Recursive call
        creal[] firstLine = pointList[0..index+1].dup;
        creal[] lastLine = pointList[index+1..$].dup;

        creal[] recResults1;
        ramerDouglasPeucker(firstLine, epsilon, recResults1);

        creal[] recResults2;
        ramerDouglasPeucker(lastLine, epsilon, recResults2);

        // Build the result list
        output = recResults1 ~ recResults2;

        enforce(output.length>=2, "Problem assembling output");
    } else {
        //Just return start and end points
        output.length = 0;
        output ~= pointList[0];
        output ~= pointList[end];
    }
}
