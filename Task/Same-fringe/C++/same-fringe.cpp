#include <algorithm>
#include <coroutine>
#include <iostream>
#include <memory>
#include <tuple>
#include <variant>

using namespace std;

class BinaryTree
{
  // C++ does not have a built in tree type.  The binary tree is a recursive
  // data type that is represented by an empty tree or a node the has a value
  // and a left and right sub-tree.  A tuple represents the node and unique_ptr
  // represents an empty vs. non-empty tree.
  using Node = tuple<BinaryTree, int, BinaryTree>;
  unique_ptr<Node> m_tree;

public:
  // Provide ways to make trees
  BinaryTree() = default; // Make an empty tree
  BinaryTree(BinaryTree&& leftChild, int value, BinaryTree&& rightChild)
  : m_tree {make_unique<Node>(move(leftChild), value, move(rightChild))} {}
  BinaryTree(int value) : BinaryTree(BinaryTree{}, value, BinaryTree{}){}
  BinaryTree(BinaryTree&& leftChild, int value)
  : BinaryTree(move(leftChild), value, BinaryTree{}){}
  BinaryTree(int value, BinaryTree&& rightChild)
  : BinaryTree(BinaryTree{}, value, move(rightChild)){}

  // Test if the tree is empty
  explicit operator bool() const
  {
    return (bool)m_tree;
  }

  // Get the value of the root node of the tree
  int Value() const
  {
    return get<1>(*m_tree);
  }

  // Get the left child tree
  const BinaryTree& LeftChild() const
  {
    return get<0>(*m_tree);
  }

  // Get the right child tree
  const BinaryTree& RightChild() const
  {
    return get<2>(*m_tree);
  }
};

// Define a promise type to be used for coroutines
struct TreeWalker {
  struct promise_type {
    int val;

    suspend_never initial_suspend() noexcept {return {};}
    suspend_never return_void() noexcept {return {};}
    suspend_always final_suspend() noexcept {return {};}
    void unhandled_exception() noexcept { }

    TreeWalker get_return_object()
    {
      return TreeWalker{coroutine_handle<promise_type>::from_promise(*this)};
    }

    suspend_always yield_value(int x) noexcept
    {
      val=x;
      return {};
    }
  };

  coroutine_handle<promise_type> coro;

  TreeWalker(coroutine_handle<promise_type> h): coro(h) {}

  ~TreeWalker()
  {
    if(coro) coro.destroy();
  }

  // Define an iterator type to work with the coroutine
  class Iterator
  {
    const coroutine_handle<promise_type>* m_h = nullptr;

  public:
    Iterator() = default;
    constexpr Iterator(const coroutine_handle<promise_type>* h) : m_h(h){}

    Iterator& operator++()
    {
      m_h->resume();
      return *this;
    }

    Iterator operator++(int)
    {
      auto old(*this);
      m_h->resume();
      return old;
    }

    int operator*() const
    {
      return m_h->promise().val;
    }

    bool operator!=(monostate) const noexcept
    {
      return !m_h->done();
      return m_h && !m_h->done();
    }

    bool operator==(monostate) const noexcept
    {
      return !operator!=(monostate{});
    }
  };

  constexpr Iterator begin() const noexcept
  {
    return Iterator(&coro);
  }

  constexpr monostate end() const noexcept
  {
    return monostate{};
  }
};

// Allow the iterator to be used like a standard library iterator
namespace std {
    template<>
    class iterator_traits<TreeWalker::Iterator>
    {
    public:
        using difference_type = std::ptrdiff_t;
        using size_type = std::size_t;
        using value_type = int;
        using pointer = int*;
        using reference = int&;
        using iterator_category = std::input_iterator_tag;
    };
}

// A coroutine that iterates though all of the fringe nodes
TreeWalker WalkFringe(const BinaryTree& tree)
{
  if(tree)
  {
    auto& left = tree.LeftChild();
    auto& right = tree.RightChild();
    if(!left && !right)
    {
      // a fringe node because it has no children
      co_yield tree.Value();
    }

    for(auto v : WalkFringe(left))
    {
      co_yield v;
    }

    for(auto v : WalkFringe(right))
    {
      co_yield v;
    }
  }
  co_return;
}

// Print a tree
void PrintTree(const BinaryTree& tree)
{
  if(tree)
  {
    cout << "(";
    PrintTree(tree.LeftChild());
    cout << tree.Value();
    PrintTree(tree.RightChild());
    cout <<")";
  }
}

// Compare two trees
void Compare(const BinaryTree& tree1, const BinaryTree& tree2)
{
  // Create a lazy range for both trees
  auto walker1 = WalkFringe(tree1);
  auto walker2 = WalkFringe(tree2);

  // Compare the ranges.
  bool sameFringe = ranges::equal(walker1.begin(), walker1.end(),
               walker2.begin(), walker2.end());

  // Print the results
  PrintTree(tree1);
  cout << (sameFringe ? " has same fringe as " : " has different fringe than ");
  PrintTree(tree2);
  cout << "\n";
}

int main()
{
  // Create two trees that that are different but have the same fringe nodes
  BinaryTree tree1(BinaryTree{6}, 77, BinaryTree{BinaryTree{3}, 77,
    BinaryTree{77, BinaryTree{9}}});
  BinaryTree tree2(BinaryTree{BinaryTree{BinaryTree{6}, 77}, 77, BinaryTree{
    BinaryTree{3}, 77, BinaryTree{9}}});
  // Create a tree with a different fringe
  BinaryTree tree3(BinaryTree{BinaryTree{BinaryTree{6}, 77}, 77, BinaryTree{77, BinaryTree{9}}});

  // Compare the trees
  Compare(tree1, tree2);
  Compare(tree1, tree3);
}
