#include <iostream>
#include <array>
#include <string>
using namespace std;

int main()
{
    const array<string, 12> days
    {
        "first",
        "second",
        "third",
        "fourth",
        "fifth",
        "sixth",
        "seventh",
        "eighth",
        "ninth",
        "tenth",
        "eleventh",
        "twelfth"
    };

    const array<string, 12> gifts
    {
        "And a partridge in a pear tree",
        "Two turtle doves",
        "Three french hens",
        "Four calling birds",
        "FIVE GOLDEN RINGS",
        "Six geese a-laying",
        "Seven swans a-swimming",
        "Eight maids a-milking",
        "Nine ladies dancing",
        "Ten lords a-leaping",
        "Eleven pipers piping",
        "Twelve drummers drumming"
    };

    for(int i = 0; i < days.size(); ++i)
    {
        cout << "On the " << days[i] << " day of christmas, my true love gave to me\n";

        if(i == 0)
        {
            cout << "A partridge in a pear tree\n";
        }
        else
        {
            int j = i + 1;
            while(j-- > 0) cout << gifts[j] << '\n';
        }

        cout << '\n';
    }

    return 0;
}
