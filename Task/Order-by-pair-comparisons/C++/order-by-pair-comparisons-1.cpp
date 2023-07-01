#include <algorithm>
#include <iostream>
#include <vector>

using namespace std;

bool InteractiveCompare(const string& s1, const string& s2)
{
    if(s1 == s2) return false;  // don't ask to compare items that are the same
    static int count = 0;
    string response;
    cout << "(" << ++count << ") Is " << s1 << " < " << s2 << "? ";
    getline(cin, response);
    return !response.empty() && response.front() == 'y';
}

void PrintOrder(const vector<string>& items)
{
    cout << "{ ";
    for(auto& item : items) cout << item << " ";
    cout << "}\n";
}

int main()
{
    const vector<string> items
    {
        "violet", "red", "green", "indigo", "blue", "yellow", "orange"
    };

    vector<string> sortedItems;

    // Use a binary insertion sort to order the items.  It should ask for
    // close to the minimum number of questions required
    for(auto& item : items)
    {
        cout << "Inserting '" << item << "' into ";
        PrintOrder(sortedItems);
        // lower_bound performs the binary search using InteractiveCompare to
        // rank the items
        auto spotToInsert = lower_bound(sortedItems.begin(),
                                        sortedItems.end(), item, InteractiveCompare);
        sortedItems.insert(spotToInsert, item);
    }
    PrintOrder(sortedItems);
    return 0;
}
