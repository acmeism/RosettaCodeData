#include <iostream>
#include <iterator>

int main() {
    using namespace std;
    noskipws(cin);
    copy(
        istream_iterator<char>(cin),
        istream_iterator<char>(),
        ostream_iterator<char>(cout)
    );
    return 0;
}
