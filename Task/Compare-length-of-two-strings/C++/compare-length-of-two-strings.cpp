#include <iostream>
#include <algorithm>
#include <string>
#include <list>

using namespace std;

bool cmp(const string& a, const string& b)
{
    return b.length() < a.length(); // reverse sort!
}

void compareAndReportStringsLength(list<string> listOfStrings)
{
    if (!listOfStrings.empty())
    {
        char Q = '"';
        string has_length(" has length ");
        string predicate_max(" and is the longest string");
        string predicate_min(" and is the shortest string");
        string predicate_ave(" and is neither the longest nor the shortest string");

        list<string> ls(listOfStrings); // clone to avoid side-effects
        ls.sort(cmp);
        int max = ls.front().length();
        int min = ls.back().length();

        for (list<string>::iterator s = ls.begin(); s != ls.end(); s++)
        {
            int length = s->length();
            string* predicate;
            if (length == max)
                predicate = &predicate_max;
            else if (length == min)
                predicate = &predicate_min;
            else
                predicate = &predicate_ave;

            cout << Q << *s << Q << has_length << length << *predicate << endl;
        }
    }
}

int main(int argc, char* argv[])
{
    list<string> listOfStrings{ "abcd", "123456789", "abcdef", "1234567" };
    compareAndReportStringsLength(listOfStrings);

    return EXIT_SUCCESS;
}
