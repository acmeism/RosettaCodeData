#include <fstream>
using namespace std;

int main()
{
    ofstream file("new.txt");
    file << "this is a string";
    file.close();
    return 0;
}
