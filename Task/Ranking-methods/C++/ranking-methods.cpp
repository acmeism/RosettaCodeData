#include <algorithm>
#include <iomanip>
#include <iostream>
#include <map>
#include <ostream>
#include <set>
#include <vector>

template<typename T>
std::ostream& print(std::ostream& os, const T& src) {
    auto it = src.cbegin();
    auto end = src.cend();

    os << "[";
    if (it != end) {
        os << *it;
        it = std::next(it);
    }
    while (it != end) {
        os << ", " << *it;
        it = std::next(it);
    }

    return os << "]";
}

typedef std::map<std::string, int> Map;
typedef Map::value_type MapEntry;

void standardRank(const Map& scores) {
    std::cout << "Standard Rank" << std::endl;

    std::vector<int> list;
    for (auto& elem : scores) {
        list.push_back(elem.second);
    }
    std::sort(list.begin(), list.end(), std::greater<int>{});
    list.erase(std::unique(list.begin(), list.end()), list.end());

    int rank = 1;
    for (auto value : list) {
        int temp = rank;
        for (auto& e : scores) {
            if (e.second == value) {
                std::cout << temp << " " << value << " " << e.first.c_str() << std::endl;
                rank++;
            }
        }
    }

    std::cout << std::endl;
}

void modifiedRank(const Map& scores) {
    std::cout << "Modified Rank" << std::endl;

    std::vector<int> list;
    for (auto& elem : scores) {
        list.push_back(elem.second);
    }
    std::sort(list.begin(), list.end(), std::greater<int>{});
    list.erase(std::unique(list.begin(), list.end()), list.end());

    int rank = 0;
    for (auto value : list) {
        rank += std::count_if(scores.begin(), scores.end(), [value](const MapEntry& e) { return e.second == value; });
        for (auto& e : scores) {
            if (e.second == value) {
                std::cout << rank << " " << value << " " << e.first.c_str() << std::endl;
            }
        }
    }

    std::cout << std::endl;
}

void denseRank(const Map& scores) {
    std::cout << "Dense Rank" << std::endl;

    std::vector<int> list;
    for (auto& elem : scores) {
        list.push_back(elem.second);
    }
    std::sort(list.begin(), list.end(), std::greater<int>{});
    list.erase(std::unique(list.begin(), list.end()), list.end());

    int rank = 1;
    for (auto value : list) {
        for (auto& e : scores) {
            if (e.second == value) {
                std::cout << rank << " " << value << " " << e.first.c_str() << std::endl;
            }
        }
        rank++;
    }

    std::cout << std::endl;
}

void ordinalRank(const Map& scores) {
    std::cout << "Ordinal Rank" << std::endl;

    std::vector<int> list;
    for (auto& elem : scores) {
        list.push_back(elem.second);
    }
    std::sort(list.begin(), list.end(), std::greater<int>{});
    list.erase(std::unique(list.begin(), list.end()), list.end());

    int rank = 1;
    for (auto value : list) {
        for (auto& e : scores) {
            if (e.second == value) {
                std::cout << rank++ << " " << value << " " << e.first.c_str() << std::endl;
            }
        }
    }

    std::cout << std::endl;
}

void fractionalRank(const Map& scores) {
    std::cout << "Ordinal Rank" << std::endl;

    std::vector<int> list;
    for (auto& elem : scores) {
        list.push_back(elem.second);
    }
    std::sort(list.begin(), list.end(), std::greater<int>{});
    list.erase(std::unique(list.begin(), list.end()), list.end());

    int rank = 0;
    for (auto value : list) {
        double avg = 0.0;
        int cnt = 0;

        for (auto& e : scores) {
            if (e.second == value) {
                rank++;
                cnt++;
                avg += rank;
            }
        }
        avg /= cnt;

        for (auto& e : scores) {
            if (e.second == value) {
                std::cout << std::setprecision(1) << std::fixed << avg << " " << value << " " << e.first.c_str() << std::endl;
            }
        }
    }

    std::cout << std::endl;
}

int main() {
    using namespace std;

    map<string, int> scores{
        {"Solomon", 44},
        {"Jason", 42},
        {"Errol", 42},
        {"Gary", 41},
        {"Bernard", 41},
        {"Barry", 41},
        {"Stephen", 39}
    };

    standardRank(scores);
    modifiedRank(scores);
    denseRank(scores);
    ordinalRank(scores);
    fractionalRank(scores);

    return 0;
}
