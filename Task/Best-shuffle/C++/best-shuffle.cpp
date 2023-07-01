#include <iostream>
#include <sstream>
#include <algorithm>

using namespace std;

template <class S>
class BestShuffle {
public:
    BestShuffle() : rd(), g(rd()) {}

    S operator()(const S& s1) {
        S s2 = s1;
        shuffle(s2.begin(), s2.end(), g);
        for (unsigned i = 0; i < s2.length(); i++)
            if (s2[i] == s1[i])
                for (unsigned j = 0; j < s2.length(); j++)
                    if (s2[i] != s2[j] && s2[i] != s1[j] && s2[j] != s1[i]) {
                        swap(s2[i], s2[j]);
                        break;
                    }
        ostringstream os;
        os << s1 << endl << s2 << " [" << count(s2, s1) << ']';
        return os.str();
    }

private:
    static int count(const S& s1, const S& s2) {
        auto count = 0;
        for (unsigned i = 0; i < s1.length(); i++)
            if (s1[i] == s2[i])
                count++;
        return count;
    }

    random_device rd;
    mt19937 g;
};

int main(int argc, char* arguments[]) {
    BestShuffle<basic_string<char>> bs;
    for (auto i = 1; i < argc; i++)
        cout << bs(basic_string<char>(arguments[i])) << endl;
    return 0;
}
