#include <vector>
#include <list>
#include <algorithm>
#include <iostream>

template <typename T>
struct Node {
    T value;
    Node* prev_node;
};

template <typename Container>
Container lis(const Container& values) {
    using E = typename Container::value_type;
    using NodePtr = Node<E>*;
    using ConstNodePtr = const NodePtr;

    std::vector<NodePtr> pileTops;
    std::vector<Node<E>> nodes(values.size());

    // sort into piles
    auto cur_node = std::begin(nodes);
    for (auto cur_value = std::begin(values); cur_value != std::end(values); ++cur_value, ++cur_node)
    {
        auto node = &*cur_node;
        node->value = *cur_value;

        // lower_bound returns the first element that is not less than 'node->value'
        auto lb = std::lower_bound(pileTops.begin(), pileTops.end(), node,
            [](ConstNodePtr& node1, ConstNodePtr& node2) -> bool { return node1->value < node2->value; });

        if (lb != pileTops.begin())
            node->prev_node = *std::prev(lb);

        if (lb == pileTops.end())
            pileTops.push_back(node);
        else
            *lb = node;
    }

    // extract LIS from piles
    // note that LIS length is equal to the number of piles
    Container result(pileTops.size());
    auto r = std::rbegin(result);

    for (NodePtr node = pileTops.back(); node != nullptr; node = node->prev_node, ++r)
        *r = node->value;

    return result;
}

template <typename Container>
void show_lis(const Container& values)
{
    auto&& result = lis(values);
    for (auto& r : result) {
        std::cout << r << ' ';
    }
    std::cout << std::endl;
}

int main()
{
    show_lis(std::list<int> { 3, 2, 6, 4, 5, 1 });
    show_lis(std::vector<int> { 0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15 });
}
