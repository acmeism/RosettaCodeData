#include <iomanip>
#include <iostream>

#define _USE_MATH_DEFINES
#include <math.h>

constexpr double degrees(double deg) {
    const double tau = 2.0 * M_PI;
    return deg * tau / 360.0;
}

const double part_ratio = 2.0 * cos(degrees(72));
const double side_ratio = 1.0 / (part_ratio + 2.0);

/// Define a position
struct Point {
    double x, y;

    friend std::ostream& operator<<(std::ostream& os, const Point& p);
};

std::ostream& operator<<(std::ostream& os, const Point& p) {
    auto f(std::cout.flags());
    os << std::setprecision(3) << std::fixed << p.x << ',' << p.y << ' ';
    std::cout.flags(f);
    return os;
}

/// Mock turtle implementation sufficiant to handle "drawing" the pentagons
struct Turtle {
private:
    Point pos;
    double theta;
    bool tracing;

public:
    Turtle() : theta(0.0), tracing(false) {
        pos.x = 0.0;
        pos.y = 0.0;
    }

    Turtle(double x, double y) : theta(0.0), tracing(false) {
        pos.x = x;
        pos.y = y;
    }

    Point position() {
        return pos;
    }
    void position(const Point& p) {
        pos = p;
    }

    double heading() {
        return theta;
    }
    void heading(double angle) {
        theta = angle;
    }

    /// Move the turtle through space
    void forward(double dist) {
        auto dx = dist * cos(theta);
        auto dy = dist * sin(theta);

        pos.x += dx;
        pos.y += dy;

        if (tracing) {
            std::cout << pos;
        }
    }

    /// Turn the turtle
    void right(double angle) {
        theta -= angle;
    }

    /// Start/Stop exporting the points of the polygon
    void begin_fill() {
        if (!tracing) {
            std::cout << "<polygon points=\"";
            tracing = true;
        }
    }
    void end_fill() {
        if (tracing) {
            std::cout << "\"/>\n";
            tracing = false;
        }
    }
};

/// Use the provided turtle to draw a pentagon of the specified size
void pentagon(Turtle& turtle, double size) {
    turtle.right(degrees(36));
    turtle.begin_fill();
    for (size_t i = 0; i < 5; i++) {
        turtle.forward(size);
        turtle.right(degrees(72));
    }
    turtle.end_fill();
}

/// Draw a sierpinski pentagon of the desired order
void sierpinski(int order, Turtle& turtle, double size) {
    turtle.heading(0.0);
    auto new_size = size * side_ratio;

    if (order-- > 1) {
        // create four more turtles
        for (size_t j = 0; j < 4; j++) {
            turtle.right(degrees(36));

            double small = size * side_ratio / part_ratio;
            auto distList = { small, size, size, small };
            auto dist = *(distList.begin() + j);

            Turtle spawn{ turtle.position().x, turtle.position().y };
            spawn.heading(turtle.heading());
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
    if (order > 0) {
        std::cout << '\n';
    }
}

/// Run the generation of a P(5) sierpinksi pentagon
int main() {
    const int order = 5;
    double size = 500;

    Turtle turtle{ size / 2.0, size };

    std::cout << "<?xml version=\"1.0\" standalone=\"no\"?>\n";
    std::cout << "<!DOCTYPE svg PUBLIC \" -//W3C//DTD SVG 1.1//EN\"\n";
    std::cout << "    \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">\n";
    std::cout << "<svg height=\"" << size << "\" width=\"" << size << "\" style=\"fill:blue\" transform=\"translate(" << size / 2 << ", " << size / 2 << ") rotate(-36)\"\n";
    std::cout << "    version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">\n";

    size *= part_ratio;
    sierpinski(order, turtle, size);

    std::cout << "</svg>";
}
