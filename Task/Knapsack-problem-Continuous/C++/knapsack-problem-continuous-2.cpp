// C++11 version
#include <iostream>
#include <vector>
#include <algorithm>
#include <string>

using namespace std;

struct item_type
{
    double  weight, value;
    string  name;
};

vector< item_type > items =
{
    { 3.8, 36, "beef"    },
    { 5.4, 43, "pork"    },
    { 3.6, 90, "ham"     },
    { 2.4, 45, "greaves" },
    { 4.0, 30, "flitch"  },
    { 2.5, 56, "brawn"   },
    { 3.7, 67, "welt"    },
    { 3.0, 95, "salami"  },
    { 5.9, 98, "sausage" }
};

int main()
{
    sort
    (
        begin( items ), end( items ),
        [] (const item_type& a, const item_type& b)
        {
            return a.value / a.weight > b.value / b.weight;
        }
    );

    double space = 15;

    for ( const auto& item : items )
    {
        if ( space >= item.weight )
            cout << "Take all " << item.name << endl;
        else
        {
            cout << "Take " << space << "kg of " << item.name << endl;
            break;
        }

        space -= item.weight;
    }
}
