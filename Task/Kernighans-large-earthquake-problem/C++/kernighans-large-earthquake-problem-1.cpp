// Randizo was here!
#include <iostream>
#include <fstream>
#include <string>
using namespace std;

int main()
{
    ifstream file("../include/earthquake.txt");

    int count_quake = 0;
    int column = 1;
    string value;
    double size_quake;
    string row = "";


    while(file >> value)
    {
        if(column == 3)
        {
            size_quake = stod(value);

            if(size_quake>6.0)
            {
                count_quake++;
                row += value + "\t";
                cout << row << endl;
            }

            column = 1;
            row = "";
        }
        else
        {
            column++;
            row+=value + "\t";
        }
    }

    cout << "\nNumber of quakes greater than 6 is " << count_quake << endl;

    return 0;
}
