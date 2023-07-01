#include <iostream>
#include <string>
#include <map>

template<typename map_type>
map_type merge(const map_type& original, const map_type& update) {
    map_type result(update);
    result.insert(original.begin(), original.end());
    return result;
}

int main() {
    typedef std::map<std::string, std::string> map;
    map original{
        {"name", "Rocket Skates"},
        {"price", "12.75"},
        {"color", "yellow"}
    };
    map update{
        {"price", "15.25"},
        {"color", "red"},
        {"year", "1974"}
    };
    map merged(merge(original, update));
    for (auto&& i : merged)
        std::cout << "key: " << i.first << ", value: " << i.second << '\n';
    return 0;
}
