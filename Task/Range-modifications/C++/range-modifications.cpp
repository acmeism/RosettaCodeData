#include <algorithm>
#include <iomanip>
#include <iostream>
#include <list>

struct range {
    range(int lo, int hi) : low(lo), high(hi) {}
    int low;
    int high;
};

std::ostream& operator<<(std::ostream& out, const range& r) {
    return out << r.low << '-' << r.high;
}

class ranges {
public:
    ranges() {}
    explicit ranges(std::initializer_list<range> init) : ranges_(init) {}
    void add(int n);
    void remove(int n);
    bool empty() const { return ranges_.empty(); }
private:
    friend std::ostream& operator<<(std::ostream& out, const ranges& r);
    std::list<range> ranges_;
};

void ranges::add(int n) {
    for (auto i = ranges_.begin(); i != ranges_.end(); ++i) {
        if (n + 1 < i->low) {
            ranges_.emplace(i, n, n);
            return;
        }
        if (n > i->high + 1)
            continue;
        if (n + 1 == i->low)
            i->low = n;
        else if (n == i->high + 1)
            i->high = n;
        else
            return;
        if (i != ranges_.begin()) {
            auto prev = std::prev(i);
            if (prev->high + 1 == i->low) {
                i->low = prev->low;
                ranges_.erase(prev);
            }
        }
        auto next = std::next(i);
        if (next != ranges_.end() && next->low - 1 == i->high) {
            i->high = next->high;
            ranges_.erase(next);
        }
        return;
    }
    ranges_.emplace_back(n, n);
}

void ranges::remove(int n) {
    for (auto i = ranges_.begin(); i != ranges_.end(); ++i) {
        if (n < i->low)
            return;
        if (n == i->low) {
            if (++i->low > i->high)
                ranges_.erase(i);
            return;
        }
        if (n == i->high) {
            if (--i->high < i->low)
                ranges_.erase(i);
            return;
        }
        if (n > i->low & n < i->high) {
            int low = i->low;
            i->low = n + 1;
            ranges_.emplace(i, low, n - 1);
            return;
        }
    }
}

std::ostream& operator<<(std::ostream& out, const ranges& r) {
    if (!r.empty()) {
        auto i = r.ranges_.begin();
        out << *i++;
        for (; i != r.ranges_.end(); ++i)
            out << ',' << *i;
    }
    return out;
}

void test_add(ranges& r, int n) {
    r.add(n);
    std::cout << "       add " << std::setw(2) << n << " => " << r << '\n';
}

void test_remove(ranges& r, int n) {
    r.remove(n);
    std::cout << "    remove " << std::setw(2) << n << " => " << r << '\n';
}

void test1() {
    ranges r;
    std::cout << "Start: \"" << r << "\"\n";
    test_add(r, 77);
    test_add(r, 79);
    test_add(r, 78);
    test_remove(r, 77);
    test_remove(r, 78);
    test_remove(r, 79);
}

void test2() {
    ranges r{{1,3}, {5,5}};
    std::cout << "Start: \"" << r << "\"\n";
    test_add(r, 1);
    test_remove(r, 4);
    test_add(r, 7);
    test_add(r, 8);
    test_add(r, 6);
    test_remove(r, 7);
}

void test3() {
    ranges r{{1,5}, {10,25}, {27,30}};
    std::cout << "Start: \"" << r << "\"\n";
    test_add(r, 26);
    test_add(r, 9);
    test_add(r, 7);
    test_remove(r, 26);
    test_remove(r, 9);
    test_remove(r, 7);
}

int main() {
    test1();
    std::cout << '\n';
    test2();
    std::cout << '\n';
    test3();
    return 0;
}
