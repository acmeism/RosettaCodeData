#include <cassert>
#include <functional>
#include <iostream>

#define _USE_MATH_DEFINES
#include <math.h>

enum RangeType {
    CLOSED,
    BOTH_OPEN,
    LEFT_OPEN,
    RIGHT_OPEN
};

class RealSet {
private:
    double low, high;
    double interval = 0.00001;
    std::function<bool(double)> predicate;

public:
    RealSet(double low, double high, const std::function<bool(double)>& predicate) {
        this->low = low;
        this->high = high;
        this->predicate = predicate;
    }

    RealSet(double start, double end, RangeType rangeType) {
        low = start;
        high = end;

        switch (rangeType) {
        case CLOSED:
            predicate = [start, end](double d) { return start <= d && d <= end; };
            break;
        case BOTH_OPEN:
            predicate = [start, end](double d) { return start < d && d < end; };
            break;
        case LEFT_OPEN:
            predicate = [start, end](double d) { return start < d && d <= end; };
            break;
        case RIGHT_OPEN:
            predicate = [start, end](double d) { return start <= d && d < end; };
            break;
        default:
            assert(!"Unexpected range type encountered.");
        }
    }

    bool contains(double d) const {
        return predicate(d);
    }

    RealSet unionSet(const RealSet& rhs) const {
        double low2 = fmin(low, rhs.low);
        double high2 = fmax(high, rhs.high);
        return RealSet(
            low2, high2,
            [this, &rhs](double d) { return predicate(d) || rhs.predicate(d); }
        );
    }

    RealSet intersect(const RealSet& rhs) const {
        double low2 = fmin(low, rhs.low);
        double high2 = fmax(high, rhs.high);
        return RealSet(
            low2, high2,
            [this, &rhs](double d) { return predicate(d) && rhs.predicate(d); }
        );
    }

    RealSet subtract(const RealSet& rhs) const {
        return RealSet(
            low, high,
            [this, &rhs](double d) { return predicate(d) && !rhs.predicate(d); }
        );
    }

    double length() const {
        if (isinf(low) || isinf(high)) return -1.0; // error value
        if (high <= low) return 0.0;

        double p = low;
        int count = 0;
        do {
            if (predicate(p)) count++;
            p += interval;
        } while (p < high);
        return count * interval;
    }

    bool empty() const {
        if (high == low) {
            return !predicate(low);
        }
        return length() == 0.0;
    }
};

int main() {
    using namespace std;

    RealSet a(0.0, 1.0, LEFT_OPEN);
    RealSet b(0.0, 2.0, RIGHT_OPEN);
    RealSet c(1.0, 2.0, LEFT_OPEN);
    RealSet d(0.0, 3.0, RIGHT_OPEN);
    RealSet e(0.0, 1.0, BOTH_OPEN);
    RealSet f(0.0, 1.0, CLOSED);
    RealSet g(0.0, 0.0, CLOSED);

    for (int i = 0; i <= 2; ++i) {
        cout << "(0, 1] ∪ [0, 2) contains " << i << " is " << boolalpha << a.unionSet(b).contains(i) << "\n";
        cout << "[0, 2) ∩ (1, 2] contains " << i << " is " << boolalpha << b.intersect(c).contains(i) << "\n";
        cout << "[0, 3) - (0, 1) contains " << i << " is " << boolalpha << d.subtract(e).contains(i) << "\n";
        cout << "[0, 3) - [0, 1] contains " << i << " is " << boolalpha << d.subtract(f).contains(i) << "\n";
        cout << endl;
    }

    cout << "[0, 0] is empty is " << boolalpha << g.empty() << "\n";
    cout << endl;

    RealSet aa(
        0.0, 10.0,
        [](double x) { return (0.0 < x && x < 10.0) && abs(sin(M_PI * x * x)) > 0.5; }
    );
    RealSet bb(
        0.0, 10.0,
        [](double x) { return (0.0 < x && x < 10.0) && abs(sin(M_PI * x)) > 0.5; }
    );
    auto cc = aa.subtract(bb);
    cout << "Approximate length of A - B is " << cc.length() << endl;

    return 0;
}
