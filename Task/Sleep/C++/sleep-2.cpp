#include <unistd.h>
#include <iostream>

using namespace std;

int main(int argc, char* argv[])
{
    useconds_t microseconds;
    cin >> microseconds;
    cout << "Sleeping..." << endl;
    usleep(microseconds);
    cout << "Awake!" << endl;
    return 0;
}
