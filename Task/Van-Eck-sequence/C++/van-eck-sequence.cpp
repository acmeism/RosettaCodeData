#include <iostream>
#include <map>

class van_eck_generator {
public:
    int next() {
        int result = last_term;
        auto iter = last_pos.find(last_term);
        int next_term = (iter != last_pos.end()) ? index - iter->second : 0;
        last_pos[last_term] = index;
        last_term = next_term;
        ++index;
        return result;
    }
private:
    int index = 0;
    int last_term = 0;
    std::map<int, int> last_pos;
};

int main() {
    van_eck_generator gen;
    int i = 0;
    std::cout << "First 10 terms of the Van Eck sequence:\n";
    for (; i < 10; ++i)
        std::cout << gen.next() << ' ';
    for (; i < 990; ++i)
        gen.next();
    std::cout << "\nTerms 991 to 1000 of the sequence:\n";
    for (; i < 1000; ++i)
        std::cout << gen.next() << ' ';
    std::cout << '\n';
    return 0;
}
