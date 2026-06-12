#include <iostream>
#include <optional>
#include <string>
#include <variant>
#include <vector>

// A variant is a sum type, it can hold exaclty one type at a time
std::variant<int, std::string, bool, int> myVariant{"Ukraine"};

struct Tree
{
  // Variants can be used in recusive data types to define structures like
  // trees.  Here the node of a tree is represented by a variant of either
  // an int or a vector of sub-trees.
  std::variant<std::vector<Tree>, int> Nodes;
};

Tree tree1; // empty tree
Tree tree2{2}; // a tree with a single value

// a bigger tree
Tree tree3{std::vector{Tree{3}, Tree{std::vector{Tree{2}, Tree{7}}}, Tree{8}}};

// optional is a special case of a sum type between a value and nothing
std::optional<int> maybeInt1;    // empty optional
std::optional<int> maybeInt2{2}; // optional containing 2

// In practice pointers are often used as sum types between a valid value and null
int* intPtr1 = nullptr;  // a null int pointer

int value = 3;
int* intPtr2 = &value; // a pointer to a valid object

// Print a tree
void PrintTree(const Tree& tree)
{
  std::cout << "(";
  if(holds_alternative<int>(tree.Nodes))
  {
    std::cout << get<1>(tree.Nodes);
  }
  else
  {
    for(const auto& subtree : get<0>(tree.Nodes)) PrintTree(subtree);
  }
  std::cout <<")";
}

int main()
{
  std::cout << "myVariant: " << get<std::string>(myVariant) << "\n";

  PrintTree(tree1); std::cout << "\n";
  PrintTree(tree2); std::cout << "\n";
  PrintTree(tree3); std::cout << "\n";

  std::cout << "*maybeInt2: " << *maybeInt2 << "\n";
  std::cout << "intPtr1: " << intPtr1 << "\n";
  std::cout << "*intPtr2: " << *intPtr2 << "\n";
}
