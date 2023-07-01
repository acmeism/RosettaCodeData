#include <set>
#include <iostream>

template <class S>
auto powerset(const S& s)
{
    std::set<S> ret;
    ret.emplace();
    for (auto&& e: s) {
        std::set<S> rs;
        for (auto x: ret) {
            x.insert(e);
            rs.insert(x);
        }
        ret.insert(begin(rs), end(rs));
    }
    return ret;
}

int main()
{
    std::set<int> s = {2, 3, 5, 7};
    auto pset = powerset(s);

    for (auto&& subset: pset) {
        std::cout << "{ ";
        char const* prefix = "";
        for (auto&& e: subset) {
            std::cout << prefix << e;
            prefix = ", ";
        }
        std::cout << " }\n";
    }
}
