#include <map>
#include <algorithm>
#include <iostream>
#include <string>

using namespace std;

int main()
{
    map<string, int> myDict;
    myDict["hello"] = 1;
    myDict["world"] = 2;
    myDict["!"] = 3;

    for_each(myDict.begin(), myDict.end(),
        [](const pair<string,int>& p)
        {
            cout << "key = " << p.first << ", value = " << p.second << endl;
        });
    return 0;
}
