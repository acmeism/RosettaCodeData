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
    vector<string> items
    {
        "violet", "red", "green", "indigo", "blue", "yellow", "orange"
    };

    sort(items.begin(), items.end(), InteractiveCompare);
    PrintOrder(items);
    return 0;
}
