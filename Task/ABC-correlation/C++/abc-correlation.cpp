#include <string>
using namespace std;
bool countabc(string s)
{
    unsigned int a = 0;
    unsigned int b = 0;
    unsigned int c = 0;
    for(unsigned int i = 0; i < s.size(); i++)
    {
        if(s[i] == 'a')
        {
            a++;
        }
        if(s[i] == 'b')
        {
            b++;
        }
        if(s[i] == 'c')
        {
            c++;
        }
    }
    return (a == b) && (b == c);
}
