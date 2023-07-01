#include <vector>
#include <list>
#include <algorithm>
#include <iostream>

template <typename T>
struct Node {
    T value;
    Node* prev_node;
};

template <typename T>
bool compare (const T& node1, const T& node2)
{
    return node1->value < node2->value;
}

template <typename Container>
Container lis(const Container& values) {
    typedef typename Container::value_type E;
    typedef typename Container::const_iterator ValueConstIter;
    typedef typename Container::iterator ValueIter;
    typedef Node<E>* NodePtr;
    typedef const NodePtr ConstNodePtr;
    typedef std::vector<Node<E> > NodeVector;
    typedef std::vector<NodePtr> NodePtrVector;
    typedef typename NodeVector::iterator NodeVectorIter;
    typedef typename NodePtrVector::iterator NodePtrVectorIter;

    std::vector<NodePtr> pileTops;
    std::vector<Node<E> > nodes(values.size());

    // sort into piles
    NodeVectorIter cur_node = nodes.begin();
    for (ValueConstIter cur_value = values.begin(); cur_value != values.end(); ++cur_value, ++cur_node)
    {
    NodePtr node = &*cur_node;
    node->value = *cur_value;

    // lower_bound returns the first element that is not less than 'node->value'
    NodePtrVectorIter lb = std::lower_bound(pileTops.begin(), pileTops.end(), node, compare<NodePtr>);

    if (lb != pileTops.begin())
        node->prev_node = *(lb - 1);

    if (lb == pileTops.end())
        pileTops.push_back(node);
    else
        *lb = node;
    }

    // extract LIS from piles
    // note that LIS length is equal to the number of piles
    Container result(pileTops.size());
    std::reverse_iterator<ValueIter> r = std::reverse_iterator<ValueIter>(result.rbegin());

    for (NodePtr node = pileTops.back(); node; node = node->prev_node, ++r)
        *r = node->value;

    return result;
}

template <typename Container>
void show_lis(const Container& values)
{
    const Container& result = lis(values);
    for (typename Container::const_iterator it = result.begin(); it != result.end(); ++it) {
        std::cout << *it << ' ';
    }
    std::cout << std::endl;
}

int main()
{
    const int arr1[] = { 3, 2, 6, 4, 5, 1 };
    const int arr2[] = { 0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15 };

    std::vector<int> vec1(arr1, arr1 + sizeof(arr1) / sizeof(arr1[0]));
    std::vector<int> vec2(arr2, arr2 + sizeof(arr2) / sizeof(arr2[0]));

    show_lis(vec1);
    show_lis(vec2);
}
