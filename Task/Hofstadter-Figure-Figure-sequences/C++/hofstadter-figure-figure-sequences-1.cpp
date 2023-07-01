#include <iomanip>
#include <iostream>
#include <set>
#include <vector>

using namespace std;

unsigned hofstadter(unsigned rlistSize, unsigned slistSize)
{
    auto n = rlistSize > slistSize ? rlistSize : slistSize;
    auto rlist = new vector<unsigned> { 1, 3, 7 };
    auto slist = new vector<unsigned> { 2, 4, 5, 6 };
    auto list = rlistSize > 0 ? rlist : slist;
    auto target_size = rlistSize > 0 ? rlistSize : slistSize;

    while (list->size() > target_size) list->pop_back();

    while (list->size() < target_size)
    {
        auto lastIndex = rlist->size() - 1;
        auto lastr = (*rlist)[lastIndex];
        auto r = lastr + (*slist)[lastIndex];
        rlist->push_back(r);
        for (auto s = lastr + 1; s < r && list->size() < target_size;)
            slist->push_back(s++);
    }

    auto v = (*list)[n - 1];
    delete rlist;
    delete slist;
    return v;
}

ostream& operator<<(ostream& os, const set<unsigned>& s)
{
    cout << '(' << s.size() << "):";
    auto i = 0;
    for (auto c = s.begin(); c != s.end();)
    {
        if (i++ % 20 == 0) os << endl;
        os << setw(5) << *c++;
    }
    return os;
}

int main(int argc, const char* argv[])
{
    const auto v1 = atoi(argv[1]);
    const auto v2 = atoi(argv[2]);
    set<unsigned> r, s;
    for (auto n = 1; n <= v2; n++)
    {
        if (n <= v1)
            r.insert(hofstadter(n, 0));
        s.insert(hofstadter(0, n));
    }
    cout << "R" << r << endl;
    cout << "S" << s << endl;

    int m = max(*r.rbegin(), *s.rbegin());
    for (auto n = 1; n <= m; n++)
        if (r.count(n) == s.count(n))
            clog << "integer " << n << " either in both or neither set" << endl;

    return 0;
}
