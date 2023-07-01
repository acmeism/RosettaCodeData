#include<cstdlib>
#include<ctime>
#include<iostream>

using namespace std;
int main()
{
    int arr[10][10];
    srand(time(NULL));
    for(auto& row: arr)
        for(auto& col: row)
            col = rand() % 20 + 1;

    for(auto& row : arr) {
        for(auto& col: row) {
            cout << ' ' << col;
            if (col == 20) goto out;
        }
        cout << endl;
    }
    out:

    return 0;
}
