module air_mass_rosetta_code;

import std.math   : exp, sqrt, cos, PI;
import std.algorithm : max;
import std.stdio  : writeln, writef, writefln;
import std.format : format;

enum double EARTH_RADIUS      = 6_371_000.0;   // meters
enum double SCALE_HEIGHT      = 8_500.0;       // meters (atmospheric density scale height)
enum double LIMIT_ATMOSPHERE  = 10_000_000.0;  // meters (integration upper bound)
enum double INITIAL_STEP_SIZE = 0.001;         // meters

// Atmospheric density at `height` meters above sea level.
// @nogc because we don't use any GC features
// @safe because we don't do any unsafe operations
pure nothrow @nogc @safe
double rho(double height)
{
    return exp(-height / SCALE_HEIGHT);
}

/**
 * Height above sea level (metres) for a point at `distance` along the
 * line of sight of an observer at `altitude`, viewing at `zenithAngle`
 * degrees from vertical.
 *
 * Derived from the law of cosines on the triangle formed by the Earth's
 * centre, the observer, and the point of interest.
 */
pure nothrow @nogc @safe
double heightAtDistance(double altitude, double zenithAngle, double distance)
{
    immutable double aa = EARTH_RADIUS + altitude;
    immutable double cosAngle = cos((180.0 - zenithAngle) * PI / 180.0);
    immutable double r = sqrt(aa * aa + distance * distance
                              - 2.0 * distance * aa * cosAngle);
    return r - EARTH_RADIUS;
}

/**
 * Column density: integral of atmospheric density along the line of sight
 * for an observer at `altitude` metres, viewing at `zenithAngle` degrees.
 *
 * Uses an adaptive step size that grows with distance, keeping the
 * integration efficient as density falls off exponentially.
 */
nothrow @nogc @safe
double columnDensity(double altitude, double zenithAngle)
{
    double sum      = 0.0;
    double distance = 0.0;

    while (distance < LIMIT_ATMOSPHERE)
    {
        // Step grows with distance so we don't over-sample the thin upper atmosphere.
        immutable double step = max(distance * INITIAL_STEP_SIZE, INITIAL_STEP_SIZE);

        // Midpoint rule: sample density at the centre of the current step.
        sum += rho(heightAtDistance(altitude, zenithAngle, distance + 0.5 * step)) * step;
        distance += step;
    }
    return sum;
}

/**
 * Air mass for an observer at `altitude` metres viewing at `zenithAngle`
 * degrees from vertical, normalised to the zenith column density.
 */
nothrow @nogc @safe
double airMass(double altitude, double zenithAngle)
{
    return columnDensity(altitude, zenithAngle) / columnDensity(altitude, 0.0);
}

void main()
{
    writeln("Angle       0 m                 13700 m");
    writeln("------------------------------------------");

    foreach (zenithAngle; 0 .. 19)   // 0..18 inclusive → 0, 5, 10, … 90
    {
        immutable int    angle     = zenithAngle * 5;
        immutable double seaLevel  = airMass(0.0,      angle);
        immutable double sofia     = airMass(13_700.0, angle);

        writefln("%2d  %18.8f  %18.8f", angle, seaLevel, sofia);
    }
}
