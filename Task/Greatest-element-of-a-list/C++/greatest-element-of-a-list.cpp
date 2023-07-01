#include <algorithm>  //std::max_element
#include <iterator>   //std::begin and std::end
#include <functional> //std::less

template<class It, class Comp = std::less<>>
    //requires ForwardIterator<It> && Compare<Comp>
constexpr auto max_value(It first, It last, Comp compare = std::less{})
{
    //Precondition: first != last
    return *std::max_element(first, last, compare);
}

template<class C, class Comp = std::less<>>
    //requires Container<C> && Compare<Comp>
constexpr auto max_value(const C& container, Comp compare = std::less{})
{
    //Precondition: !container.empty()
    using std::begin; using std::end;
    return max_value(begin(container), end(container), compare);
}
