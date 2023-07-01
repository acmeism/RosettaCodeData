#include <algorithm>
#include <ctime>
#include <iostream>
#include <cstdlib>
#include <string>

using namespace std;

int main()
{
    srand(time(0));

    unsigned int attributes_total = 0;
    unsigned int count = 0;
    int attributes[6] = {};
    int rolls[4] = {};

    while(attributes_total < 75 || count < 2)
    {
        attributes_total = 0;
        count = 0;

        for(int attrib = 0; attrib < 6; attrib++)
        {
            for(int roll = 0; roll < 4; roll++)
            {
                rolls[roll] = 1 + (rand() % 6);
            }

            sort(rolls, rolls + 4);
            int roll_total = rolls[1] + rolls[2] + rolls[3];

            attributes[attrib] = roll_total;
            attributes_total += roll_total;

            if(roll_total >= 15) count++;
        }
    }

    cout << "Attributes generated : [";
    cout << attributes[0] << ", ";
    cout << attributes[1] << ", ";
    cout << attributes[2] << ", ";
    cout << attributes[3] << ", ";
    cout << attributes[4] << ", ";
    cout << attributes[5];

    cout << "]\nTotal: " << attributes_total;
    cout << ", Values above 15 : " << count;

    return 0;
}
