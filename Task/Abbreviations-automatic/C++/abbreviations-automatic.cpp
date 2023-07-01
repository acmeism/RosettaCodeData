#include <iomanip>
#include <iostream>
#include <fstream>
#include <map>
#include <sstream>
#include <string>
#include <vector>

std::vector<std::string> split(const std::string& str, char delimiter) {
    std::vector<std::string> tokens;
    std::string token;
    std::istringstream tokenStream(str);
    while (std::getline(tokenStream, token, delimiter)) {
        tokens.push_back(token);
    }
    return tokens;
}

int main() {
    using namespace std;
    string line;
    int i = 0;

    ifstream in("days_of_week.txt");
    if (in.is_open()) {
        while (getline(in, line)) {
            i++;
            if (line.empty()) {
                continue;
            }

            auto days = split(line, ' ');
            if (days.size() != 7) {
                throw std::runtime_error("There aren't 7 days in line " + i);
            }

            map<string, int> temp;
            for (auto& day : days) {
                if (temp.find(day) != temp.end()) {
                    cerr << " ∞  " << line << '\n';
                    continue;
                }
                temp[day] = 1;
            }

            int len = 1;
            while (true) {
                temp.clear();
                for (auto& day : days) {
                    string key = day.substr(0, len);
                    if (temp.find(key) != temp.end()) {
                        break;
                    }
                    temp[key] = 1;
                }
                if (temp.size() == 7) {
                    cout << setw(2) << len << "  " << line << '\n';
                    break;
                }
                len++;
            }
        }
    }

    return 0;
}
