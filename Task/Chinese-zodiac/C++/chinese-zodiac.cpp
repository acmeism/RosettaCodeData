#include <iostream>
#include <cmath>

using namespace std;

const string animals[]={"Rat","Ox","Tiger","Rabbit","Dragon","Snake","Horse","Goat","Monkey","Rooster","Dog","Pig"};
const string elements[]={"Wood","Fire","Earth","Metal","Water"};

string getElement(int year)
{
    int element = floor((year-4)%10/2);
    return elements[element];
}

string getAnimal(int year)
{
    return animals[(year-4)%12];
}

string getYY(int year)
{
    if(year%2==0)
    {
        return "yang";
    }
    else
    {
        return "yin";
    }
}

int main()
{
    int years[]={1935,1938,1968,1972,1976,2017};
    //the zodiac cycle didnt start until 4 CE, so years <4 shouldnt be valid
    for(int i=0;i<6;i++)
    {
        cout << years[i] << " is the year of the " << getElement(years[i]) << " " << getAnimal(years[i]) << " (" << getYY(years[i]) << ")." << endl;
    }
    return 0;
}
