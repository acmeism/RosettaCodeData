#include <iostream>
#include <string>
#include <vector>
#include <algorithm>

struct city {
    std::string name;
    float population;
};

int main()
{
    std::vector<city> cities = {
        { "Lagos", 21 },
        { "Cairo", 15.2 },
        { "Kinshasa-Brazzaville", 11.3 },
        { "Greater Johannesburg", 7.55 },
        { "Mogadishu", 5.85 },
        { "Khartoum-Omdurman", 4.98 },
        { "Dar Es Salaam", 4.7 },
        { "Alexandria", 4.58 },
        { "Abidjan", 4.4 },
        { "Casablanca", 3.98 },
    };

    auto i1 = std::find_if( cities.begin(), cities.end(),
        [](city c){ return c.name == "Dar Es Salaam"; } );
    if (i1 != cities.end()) {
        std::cout << i1 - cities.begin() << "\n";
    }

    auto i2 = std::find_if( cities.begin(), cities.end(),
        [](city c){ return c.population < 5.0; } );
    if (i2 != cities.end()) {
        std::cout << i2->name << "\n";
    }

    auto i3 = std::find_if( cities.begin(), cities.end(),
        [](city c){ return c.name.length() > 0 && c.name[0] == 'A'; } );
    if (i3 != cities.end()) {
        std::cout << i3->population << "\n";
    }
}
