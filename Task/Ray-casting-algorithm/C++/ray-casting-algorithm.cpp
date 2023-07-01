#include <algorithm>
#include <cstdlib>
#include <iomanip>
#include <iostream>
#include <limits>

using namespace std;

const double epsilon = numeric_limits<float>().epsilon();
const numeric_limits<double> DOUBLE;
const double MIN = DOUBLE.min();
const double MAX = DOUBLE.max();

struct Point { const double x, y; };

struct Edge {
    const Point a, b;

    bool operator()(const Point& p) const
    {
        if (a.y > b.y) return Edge{ b, a }(p);
        if (p.y == a.y || p.y == b.y) return operator()({ p.x, p.y + epsilon });
        if (p.y > b.y || p.y < a.y || p.x > max(a.x, b.x)) return false;
        if (p.x < min(a.x, b.x)) return true;
        auto blue = abs(a.x - p.x) > MIN ? (p.y - a.y) / (p.x - a.x) : MAX;
        auto red = abs(a.x - b.x) > MIN ? (b.y - a.y) / (b.x - a.x) : MAX;
        return blue >= red;
    }
};

struct Figure {
    const string  name;
    const initializer_list<Edge> edges;

    bool contains(const Point& p) const
    {
        auto c = 0;
        for (auto e : edges) if (e(p)) c++;
        return c % 2 != 0;
    }

    template<unsigned char W = 3>
    void check(const initializer_list<Point>& points, ostream& os) const
    {
        os << "Is point inside figure " << name <<  '?' << endl;
        for (auto p : points)
            os << "  (" << setw(W) << p.x << ',' << setw(W) << p.y << "): " << boolalpha << contains(p) << endl;
        os << endl;
    }
};

int main()
{
    const initializer_list<Point> points =  { { 5.0, 5.0}, {5.0, 8.0}, {-10.0, 5.0}, {0.0, 5.0}, {10.0, 5.0}, {8.0, 5.0}, {10.0, 10.0} };
    const Figure square = { "Square",
        {  {{0.0, 0.0}, {10.0, 0.0}}, {{10.0, 0.0}, {10.0, 10.0}}, {{10.0, 10.0}, {0.0, 10.0}}, {{0.0, 10.0}, {0.0, 0.0}} }
    };

    const Figure square_hole = { "Square hole",
        {  {{0.0, 0.0}, {10.0, 0.0}}, {{10.0, 0.0}, {10.0, 10.0}}, {{10.0, 10.0}, {0.0, 10.0}}, {{0.0, 10.0}, {0.0, 0.0}},
           {{2.5, 2.5}, {7.5, 2.5}}, {{7.5, 2.5}, {7.5, 7.5}}, {{7.5, 7.5}, {2.5, 7.5}}, {{2.5, 7.5}, {2.5, 2.5}}
        }
    };

    const Figure strange = { "Strange",
        {  {{0.0, 0.0}, {2.5, 2.5}}, {{2.5, 2.5}, {0.0, 10.0}}, {{0.0, 10.0}, {2.5, 7.5}}, {{2.5, 7.5}, {7.5, 7.5}},
           {{7.5, 7.5}, {10.0, 10.0}}, {{10.0, 10.0}, {10.0, 0.0}}, {{10.0, 0}, {2.5, 2.5}}
        }
    };

    const Figure exagon = { "Exagon",
        {  {{3.0, 0.0}, {7.0, 0.0}}, {{7.0, 0.0}, {10.0, 5.0}}, {{10.0, 5.0}, {7.0, 10.0}}, {{7.0, 10.0}, {3.0, 10.0}},
           {{3.0, 10.0}, {0.0, 5.0}}, {{0.0, 5.0}, {3.0, 0.0}}
        }
    };

    for(auto f : {square, square_hole, strange, exagon})
        f.check(points, cout);

    return EXIT_SUCCESS;
}
