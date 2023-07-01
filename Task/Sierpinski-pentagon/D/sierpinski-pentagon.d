import std.math;
import std.stdio;

/// Convert degrees into radians, as that is the accepted unit for sin/cos etc...
real degrees(real deg) {
    immutable tau = 2.0 * PI;
    return deg * tau / 360.0;
}

immutable part_ratio = 2.0 * cos(72.degrees);
immutable side_ratio = 1.0 / (part_ratio + 2.0);

/// Use the provided turtle to draw a pentagon of the specified size
void pentagon(Turtle turtle, real size) {
    turtle.right(36.degrees);
    turtle.begin_fill();
    foreach(i; 0..5) {
        turtle.forward(size);
        turtle.right(72.degrees);
    }
    turtle.end_fill();
}

/// Draw a sierpinski pentagon of the desired order
void sierpinski(int order, Turtle turtle, real size) {
    turtle.setheading(0.0);
    auto new_size = size * side_ratio;

    if (order-- > 1) {
        // create four more turtles
        foreach(j; 0..4) {
            turtle.right(36.degrees);
            real small = size * side_ratio / part_ratio;
            auto dist = [small, size, size, small][j];

            auto spawn = new Turtle();
            spawn.setposition(turtle.position);
            spawn.setheading(turtle.heading);
            spawn.forward(dist);

            // recurse for each spawned turtle
            sierpinski(order, spawn, new_size);
        }

        // recurse for the original turtle
        sierpinski(order, turtle, new_size);
    } else {
        // The bottom has been reached for this turtle
        pentagon(turtle, size);
    }
}

/// Run the generation of a P(5) sierpinksi pentagon
void main() {
    int order = 5;
    real size = 500;

    auto turtle = new Turtle(size/2, size);

    // Write the header to an SVG file for the image
    writeln(`<?xml version="1.0" standalone="no"?>`);
    writeln(`<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN"`);
    writeln(`    "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">`);
    writefln(`<svg height="%s" width="%s" style="fill:blue" transform="translate(%s,%s) rotate(-36)"`, size, size, size/2, size/2);
    writeln(`    version="1.1" xmlns="http://www.w3.org/2000/svg">`);
    // Write the close tag when the interior points have been written
    scope(success) writeln("</svg>");

    // Scale the initial turtle so that it stays in the inner pentagon
    size *= part_ratio;

    // Begin rendering
    sierpinski(order, turtle, size);
}

/// Define a position
struct Point {
    real x;
    real y;

    /// When a point is written, do it in the form "x,y " to three decimal places
    void toString(scope void delegate(const(char)[]) sink) const {
        import std.format;

        formattedWrite(sink, "%0.3f", x);
        sink(",");
        formattedWrite(sink, "%0.3f", y);
        sink(" ");
    }
}

/// Mock turtle implementation sufficiant to handle "drawing" the pentagons
class Turtle {
    /////////////////////////////////
    private:

    Point pos;
    real theta;
    bool tracing;

    /////////////////////////////////
    public:
    this() {
        // empty
    }

    this(real x, real y) {
        pos.x = x;
        pos.y = y;
    }

    // Get/Set the turtle position
    Point position() {
        return pos;
    }
    void setposition(Point pos) {
        this.pos = pos;
    }

    // Get/Set the turtle's heading
    real heading() {
        return theta;
    }
    void setheading(real angle) {
        theta = angle;
    }

    // Move the turtle through space
    void forward(real dist) {
        // Calculate both components at once for the specified angle
        auto delta = dist * expi(theta);

        pos.x += delta.re;
        pos.y += delta.im;

        if (tracing) {
            write(pos);
        }
    }

    // Turn the turle
    void right(real angle) {
        theta = theta - angle;
    }

    // Start/Stop exporting the points of the polygon
    void begin_fill() {
        write(`<polygon points="`);
        tracing = true;
    }
    void end_fill() {
        writeln(`"/>`);
        tracing = false;
    }
}
