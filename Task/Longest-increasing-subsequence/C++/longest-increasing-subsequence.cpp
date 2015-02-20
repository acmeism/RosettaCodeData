#include <iostream>
#include <vector>
#include <tr1/memory>
#include <algorithm>
#include <iterator>

template <typename E>
struct Node {
  E value;
  std::tr1::shared_ptr<Node<E> > pointer;
};

template <class E>
struct node_ptr_less {
  bool operator()(const std::tr1::shared_ptr<Node<E> > &node1,
		  const std::tr1::shared_ptr<Node<E> > &node2) const {
    return node1->value < node2->value;
  }
};


template <typename E>
std::vector<E> lis(const std::vector<E> &n) {
  typedef std::tr1::shared_ptr<Node<E> > NodePtr;

  std::vector<NodePtr> pileTops;
  // sort into piles
  for (typename std::vector<E>::const_iterator it = n.begin(); it != n.end(); it++) {
    NodePtr node(new Node<E>());
    node->value = *it;
    typename std::vector<NodePtr>::iterator j =
      std::lower_bound(pileTops.begin(), pileTops.end(), node, node_ptr_less<E>());
    if (j != pileTops.begin())
      node->pointer = *(j-1);
    if (j != pileTops.end())
      *j = node;
    else
      pileTops.push_back(node);
  }
  // extract LIS from piles
  std::vector<E> result;
  for (NodePtr node = pileTops.back(); node != NULL; node = node->pointer)
    result.push_back(node->value);
  std::reverse(result.begin(), result.end());
  return result;
}

int main() {
  int arr1[] = {3,2,6,4,5,1};
  std::vector<int> vec1(arr1, arr1 + sizeof(arr1)/sizeof(*arr1));
  std::vector<int> result1 = lis(vec1);
  std::copy(result1.begin(), result1.end(), std::ostream_iterator<int>(std::cout, ", "));
  std::cout << std::endl;

  int arr2[] = {0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15};
  std::vector<int> vec2(arr2, arr2 + sizeof(arr2)/sizeof(*arr2));
  std::vector<int> result2 = lis(vec2);
  std::copy(result2.begin(), result2.end(), std::ostream_iterator<int>(std::cout, ", "));
  std::cout << std::endl;
  return 0;
}
