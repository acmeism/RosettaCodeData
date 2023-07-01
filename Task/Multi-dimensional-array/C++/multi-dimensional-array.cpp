#include <iostream>
#include <vector>

// convienince for printing the contents of a collection
template<typename T>
std::ostream& operator<<(std::ostream& out, const std::vector<T>& c) {
    auto it = c.cbegin();
    auto end = c.cend();

    out << '[';
    if (it != end) {
        out << *it;
        it = std::next(it);
    }
    while (it != end) {
        out << ", " << *it;
        it = std::next(it);
    }
    return out << ']';
}

void fourDim() {
    using namespace std;

    // create a 4d jagged array, with bounds checking etc...
    vector<vector<vector<vector<int>>>> arr;
    int cnt = 0;

    arr.push_back(vector<vector<vector<int>>>{});
    arr[0].push_back(vector<vector<int>>{});
    arr[0][0].push_back(vector<int>{});
    arr[0][0][0].push_back(cnt++);
    arr[0][0][0].push_back(cnt++);
    arr[0][0][0].push_back(cnt++);
    arr[0][0][0].push_back(cnt++);
    arr[0].push_back(vector<vector<int>>{});
    arr[0][1].push_back(vector<int>{});
    arr[0][1][0].push_back(cnt++);
    arr[0][1][0].push_back(cnt++);
    arr[0][1][0].push_back(cnt++);
    arr[0][1][0].push_back(cnt++);
    arr[0][1].push_back(vector<int>{});
    arr[0][1][1].push_back(cnt++);
    arr[0][1][1].push_back(cnt++);
    arr[0][1][1].push_back(cnt++);
    arr[0][1][1].push_back(cnt++);

    arr.push_back(vector<vector<vector<int>>>{});
    arr[1].push_back(vector<vector<int>>{});
    arr[1][0].push_back(vector<int>{});
    arr[1][0][0].push_back(cnt++);
    arr[1][0][0].push_back(cnt++);
    arr[1][0][0].push_back(cnt++);
    arr[1][0][0].push_back(cnt++);

    cout << arr << '\n';
}

int main() {
    /* C++ does not have native support for multi-dimensional arrays,
     * but classes could be written to make things easier to work with.
     * There are standard library classes which can be used for single dimension arrays.
     * Also raw access is supported through pointers as in C.
     */

    fourDim();

    return 0;
}
