#include <iostream>
#include <set>

template<typename Set> std::set<Set> powerset(const Set& s, size_t n)
{
    typedef typename Set::const_iterator SetCIt;
    typedef typename std::set<Set>::const_iterator PowerSetCIt;
    std::set<Set> res;
    if(n > 0) {
        std::set<Set> ps = powerset(s, n-1);
        for(PowerSetCIt ss = ps.begin(); ss != ps.end(); ss++)
            for(SetCIt el = s.begin(); el != s.end(); el++) {
                Set subset(*ss);
                subset.insert(*el);
                res.insert(subset);
            }
        res.insert(ps.begin(), ps.end());
    } else
        res.insert(Set());
    return res;
}
template<typename Set> std::set<Set> powerset(const Set& s)
{
    return powerset(s, s.size());
}
