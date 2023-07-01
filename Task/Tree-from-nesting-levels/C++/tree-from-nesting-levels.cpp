#include <any>
#include <iostream>
#include <iterator>
#include <vector>

using namespace std;

// Make a tree that is a vector of either values or other trees
vector<any> MakeTree(input_iterator auto first, input_iterator auto last, int depth = 1)
{
    vector<any> tree;
    while (first < last && depth <= *first)
    {
        if(*first == depth)
        {
            // add a single value
            tree.push_back(*first);
            ++first;
        }
        else // (depth < *b)
        {
            // add a subtree
            tree.push_back(MakeTree(first, last, depth + 1));
            first = find(first + 1, last, depth);
        }
    }

    return tree;
}

// Print an input vector or tree
void PrintTree(input_iterator auto first, input_iterator auto last)
{
    cout << "[";
    for(auto it = first; it != last; ++it)
    {
        if(it != first) cout << ", ";
        if constexpr (is_integral_v<remove_reference_t<decltype(*first)>>)
        {
            // for printing the input vector
            cout << *it;
        }
        else
        {
            // for printing the tree
            if(it->type() == typeid(unsigned int))
            {
                // a single value
                cout << any_cast<unsigned int>(*it);
            }
            else
            {
                // a subtree
                const auto& subTree = any_cast<vector<any>>(*it);
                PrintTree(subTree.begin(), subTree.end());
            }
        }
    }
    cout << "]";
}

int main(void)
{
    auto execises = vector<vector<unsigned int>> {
        {},
        {1, 2, 4},
        {3, 1, 3, 1},
        {1, 2, 3, 1},
        {3, 2, 1, 3},
        {3, 3, 3, 1, 1, 3, 3, 3}
        };

    for(const auto& e : execises)
    {
        auto tree = MakeTree(e.begin(), e.end());
        PrintTree(e.begin(), e.end());
        cout << " Nests to:\n";
        PrintTree(tree.begin(), tree.end());
        cout << "\n\n";
    }
}
