#include <set>
#include <iostream>
using namespace std;

int main() {
    typedef set<int> TySet;
    int data[] = {1, 2, 3, 2, 3, 4};

    TySet unique_set(data, data + 6);

    cout << "Set items:" << endl;
    for (TySet::iterator iter = unique_set.begin(); iter != unique_set.end(); iter++)
          cout << *iter << " ";
    cout << endl;
}
