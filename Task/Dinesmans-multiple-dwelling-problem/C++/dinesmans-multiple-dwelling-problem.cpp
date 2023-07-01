#include <algorithm>
#include <array>
#include <cmath>
#include <functional>
#include <string>
#include <iostream>
#include <list>

int main() {
    constexpr auto floors = 5u;
    constexpr auto top = floors - 1u, bottom = 0u;

    using namespace std;
    array<string, floors> tenants = { "Baker", "Cooper", "Fletcher", "Miller", "Smith" };
    const auto floor_of = [&tenants](string t) {
        for (int i = bottom; i <= top; i++)
            if (tenants[i] == t) return i;
        throw "invalid tenant";
    };

    const list<function<bool()>> constraints = {
        [&tenants]() { return tenants[top] != "Baker"; },
        [&tenants]() { return tenants[bottom] != "Cooper"; },
        [&tenants]() { return tenants[top] != "Fletcher"; },
        [&tenants]() { return tenants[bottom] != "Fletcher"; },
        [&floor_of]() { return floor_of("Miller") > floor_of("Cooper"); },
        [&floor_of]() { return abs(floor_of("Fletcher") - floor_of("Smith")) != 1; },
        [&floor_of]() { return abs(floor_of("Fletcher") - floor_of("Cooper")) != 1; }
    };

    sort(tenants.begin(), tenants.end());
    do {
        if (all_of(constraints.begin(), constraints.end(), [](auto f) { return f(); } )) {
            for (const auto &t : tenants) cout << t << ' ';
            cout << endl;
        }
    } while (next_permutation(tenants.begin(), tenants.end()));

    return EXIT_SUCCESS;
}
