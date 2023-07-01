//#include <functional>
#include <iostream>
#include <vector>

template <typename C, typename A>
void merge2(const C& c1, const C& c2, const A& action) {
    auto i1 = std::cbegin(c1);
    auto i2 = std::cbegin(c2);

    while (i1 != std::cend(c1) && i2 != std::cend(c2)) {
        if (*i1 <= *i2) {
            action(*i1);
            i1 = std::next(i1);
        } else {
            action(*i2);
            i2 = std::next(i2);
        }
    }
    while (i1 != std::cend(c1)) {
        action(*i1);
        i1 = std::next(i1);
    }
    while (i2 != std::cend(c2)) {
        action(*i2);
        i2 = std::next(i2);
    }
}

template <typename A, typename C>
void mergeN(const A& action, std::initializer_list<C> all) {
    using I = typename C::const_iterator;
    using R = std::pair<I, I>;

    std::vector<R> vit;
    for (auto& c : all) {
        auto p = std::make_pair(std::cbegin(c), std::cend(c));
        vit.push_back(p);
    }

    bool done;
    R* least;
    do {
        done = true;

        auto it = vit.begin();
        auto end = vit.end();
        least = nullptr;

        // search for the first non-empty range to use for comparison
        while (it != end && it->first == it->second) {
            it++;
        }
        if (it != end) {
            least = &(*it);
        }
        while (it != end) {
            // search for the next non-empty range to use for comaprison
            while (it != end && it->first == it->second) {
                it++;
            }
            if (least != nullptr && it != end
                && it->first != it->second
                && *(it->first) < *(least->first)) {
                // found a smaller value
                least = &(*it);
            }
            if (it != end) {
                it++;
            }
        }
        if (least != nullptr && least->first != least->second) {
            done = false;
            action(*(least->first));
            least->first = std::next(least->first);
        }
    } while (!done);
}

void display(int num) {
    std::cout << num << ' ';
}

int main() {
    std::vector<int> v1{ 0, 3, 6 };
    std::vector<int> v2{ 1, 4, 7 };
    std::vector<int> v3{ 2, 5, 8 };

    merge2(v2, v1, display);
    std::cout << '\n';

    mergeN(display, { v1 });
    std::cout << '\n';

    mergeN(display, { v3, v2, v1 });
    std::cout << '\n';
}
