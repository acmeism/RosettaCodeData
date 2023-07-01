#include <iomanip>
#include <iostream>
#include <map>
#include <sstream>

bool isHumble(int i) {
    if (i <= 1) return true;
    if (i % 2 == 0) return isHumble(i / 2);
    if (i % 3 == 0) return isHumble(i / 3);
    if (i % 5 == 0) return isHumble(i / 5);
    if (i % 7 == 0) return isHumble(i / 7);
    return false;
}

auto toString(int n) {
    std::stringstream ss;
    ss << n;
    return ss.str();
}

int main() {
    auto limit = SHRT_MAX;
    std::map<int, int> humble;
    auto count = 0;
    auto num = 1;

    while (count < limit) {
        if (isHumble(num)) {
            auto str = toString(num);
            auto len = str.length();
            auto it = humble.find(len);

            if (it != humble.end()) {
                it->second++;
            } else {
                humble[len] = 1;
            }

            if (count < 50) std::cout << num << ' ';
            count++;
        }
        num++;
    }
    std::cout << "\n\n";

    std::cout << "Of the first " << count << " humble numbers:\n";
    num = 1;
    while (num < humble.size() - 1) {
        auto it = humble.find(num);
        if (it != humble.end()) {
            auto c = *it;
            std::cout << std::setw(5) << c.second << " have " << std::setw(2) << num << " digits\n";
            num++;
        } else {
            break;
        }
    }

    return 0;
}
