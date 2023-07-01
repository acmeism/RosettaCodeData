#include <algorithm>
#include <iostream>
#include <unordered_map>
#include <unordered_set>
#include <vector>

using namespace std;

// Consolidation using a brute force approach
void SimpleConsolidate(vector<unordered_set<char>>& sets)
{
    // Loop through the sets in reverse and consolidate them
    for(auto last = sets.rbegin(); last != sets.rend(); ++last)
        for(auto other = last + 1; other != sets.rend(); ++other)
        {
            bool hasIntersection = any_of(last->begin(), last->end(),
                                          [&](auto val)
                                          { return other->contains(val); });
            if(hasIntersection)
            {
                other->merge(*last);
                sets.pop_back();
                break;
            }
        }
}

// As a second approach, use the connected-component-finding-algorithm
// from the C# entry to consolidate
struct Node
{
    char Value;
    Node* Parent = nullptr;
};

Node* FindTop(Node& node)
{
    auto top = &node;
    while (top != top->Parent) top = top->Parent;
    for(auto element = &node; element->Parent != top; )
    {
        // Point the elements to top to make it faster for the next time
        auto parent = element->Parent;
        element->Parent = top;
        element = parent;
    }
    return top;
}

vector<unordered_set<char>> FastConsolidate(const vector<unordered_set<char>>& sets)
{
    unordered_map<char, Node> elements;
    for(auto& set : sets)
    {
        Node* top = nullptr;
        for(auto val : set)
        {
            auto itr = elements.find(val);
            if(itr == elements.end())
            {
                // A new value has been found
                auto& ref = elements[val] = Node{val, nullptr};
                if(!top) top = &ref;
                ref.Parent = top;
            }
            else
            {
                auto newTop = FindTop(itr->second);
                if(top)
                {
                    top->Parent = newTop;
                    itr->second.Parent = newTop;
                }
                else
                {
                    top = newTop;
                }
            }
        }
    }

    unordered_map<char, unordered_set<char>> groupedByTop;
    for(auto& e : elements)
    {
        auto& element = e.second;
        groupedByTop[FindTop(element)->Value].insert(element.Value);
    }

    vector<unordered_set<char>> ret;
    for(auto& itr : groupedByTop)
    {
        ret.push_back(move(itr.second));
    }

    return ret;
}

void PrintSets(const vector<unordered_set<char>>& sets)
{
    for(const auto& set : sets)
    {
        cout << "{ ";
        for(auto value : set){cout << value << " ";}
        cout << "} ";
    }
    cout << "\n";
}

int main()
{
    const unordered_set<char> AB{'A', 'B'}, CD{'C', 'D'}, DB{'D', 'B'},
                              HIJ{'H', 'I', 'K'}, FGH{'F', 'G', 'H'};

    vector <unordered_set<char>> AB_CD {AB, CD};
    vector <unordered_set<char>> AB_DB {AB, DB};
    vector <unordered_set<char>> AB_CD_DB {AB, CD, DB};
    vector <unordered_set<char>> HIJ_AB_CD_DB_FGH {HIJ, AB, CD, DB, FGH};

    PrintSets(FastConsolidate(AB_CD));
    PrintSets(FastConsolidate(AB_DB));
    PrintSets(FastConsolidate(AB_CD_DB));
    PrintSets(FastConsolidate(HIJ_AB_CD_DB_FGH));

    SimpleConsolidate(AB_CD);
    SimpleConsolidate(AB_DB);
    SimpleConsolidate(AB_CD_DB);
    SimpleConsolidate(HIJ_AB_CD_DB_FGH);

    PrintSets(AB_CD);
    PrintSets(AB_DB);
    PrintSets(AB_CD_DB);
    PrintSets(HIJ_AB_CD_DB_FGH);
}
