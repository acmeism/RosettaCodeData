#include <iostream>
#include <thread>
#include <vector>
#include <unistd.h>

using namespace std;

void sortThread( int x )
{
    usleep( 10000 * x );
    cout << x << " ";
}

int main()
{
    vector<thread*> threads;

    srand( ( unsigned )time( NULL ) );

    cout << "unsorted:" << endl;
    for( int x = 0; x < 15; x++ )
    {
        int r = rand() % 20 + 5;
        cout << r << " ";
        thread* t = new thread( sortThread, r );
        threads.push_back( t );
    }
    cout << endl << endl << "sorted:" << endl;

    for( vector<thread*>::iterator t = threads.begin(); t != threads.end(); t++ )
    {
        ( *t )->join();
        delete ( *t );
    }

    cout << endl << endl;
    return 0;
}
