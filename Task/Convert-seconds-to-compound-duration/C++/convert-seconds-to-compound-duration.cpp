#include <iostream>
#include <vector>

using entry = std::pair<int, const char*>;

void print(const std::vector<entry>& entries, std::ostream& out = std::cout)
{
    bool first = true;
    for(const auto& e: entries) {
        if(!first) out << ", ";
        first = false;
        out << e.first << " " << e.second;
    }
    out << '\n';
}

std::vector<entry> convert(int seconds)
{
    static const entry time_table[] = {
        {7*24*60*60, "wk"}, {24*60*60, "d"}, {60*60, "hr"}, {60, "min"}, {1, "sec"}
    };
    std::vector<entry> result;
    for(const auto& e: time_table) {
        int time = seconds / e.first;
        if(time != 0) result.emplace_back(time, e.second);
        seconds %= e.first;
    }
    return result;
}

int main()
{
    std::cout << "   7259 sec is "; print(convert(   7259));
    std::cout << "  86400 sec is "; print(convert(  86400));
    std::cout << "6000000 sec is "; print(convert(6000000));
}
