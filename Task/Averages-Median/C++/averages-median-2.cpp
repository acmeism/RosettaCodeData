#include <bits/stdc++.h>
#include <ext/pb_ds/assoc_container.hpp>
#include <ext/pb_ds/tree_policy.hpp>

// the std::less_equal<> comparator allows the tree to support duplicates
typedef __gnu_pbds::tree<double, __gnu_pbds::null_type, std::less_equal<double>, __gnu_pbds::rb_tree_tag, __gnu_pbds::tree_order_statistics_node_update> ost_t;

// The lookup method, find_by_order (aka Select), is O(log n) for this data structure, much faster than std::nth_element()
double median(ost_t &OST)
{
    int n = OST.size();
    int m = n/2;
    if (n == 1)
        return *OST.find_by_order(0);
    if (n == 2)
        return (*OST.find_by_order(0) + *OST.find_by_order(1)) / 2;

    if (n & 1) // odd number of elements
        return *OST.find_by_order(m);
    else // even number of elements
        return (*OST.find_by_order(m) + *OST.find_by_order(m-1)) / 2;
}

int main(int argc, char* argv[])
{
    ost_t ostree;

    // insertion is also O(log n) for OSTs
    ostree.insert(4.1);
    ostree.insert(7.2);
    ostree.insert(1.7);
    ostree.insert(9.3);
    ostree.insert(4.4);
    ostree.insert(3.2);

    printf("%.3f\n", median(ostree)); // 4.250

    return 0;
}
