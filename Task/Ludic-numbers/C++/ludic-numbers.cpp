#include <vector>
#include <iostream>
using namespace std;

class ludic
{
public:
    void ludicList()
    {
        _list.push_back( 1 );

        vector<int> v;
        for( int x = 2; x < 22000; x++ )
            v.push_back( x );

        while( true )
        {
            vector<int>::iterator i = v.begin();
            int z = *i;
            _list.push_back( z );

            while( true )
            {
                i = v.erase( i );
                if( distance( i, v.end() ) <= z - 1 ) break;
                advance( i, z - 1 );
            }
            if( v.size() < 1 ) return;
        }
    }

    void show( int s, int e )
    {
        for( int x = s; x < e; x++ )
            cout << _list[x] << " ";
    }

    void findTriplets( int e )
    {
        int lu, x = 0;
        while( _list[x] < e )
        {
            lu = _list[x];
            if( inList( lu + 2 ) && inList( lu + 6 ) )
                cout << "(" << lu << " " << lu + 2 << " " << lu + 6 << ")\n";
            x++;
        }
    }

    int count( int e )
    {
        int x = 0, c = 0;
        while( _list[x++] <= 1000 ) c++;
        return c;
    }

private:
    bool inList( int lu )
    {
        for( int x = 0; x < 250; x++ )
            if( _list[x] == lu ) return true;
        return false;
    }

    vector<int> _list;
};

int main( int argc, char* argv[] )
{
    ludic l;
    l.ludicList();
    cout << "first 25 ludic numbers:" << "\n";
    l.show( 0, 25 );
    cout << "\n\nThere are " << l.count( 1000 ) << " ludic numbers <= 1000" << "\n";
    cout << "\n2000 to 2005'th ludic numbers:" << "\n";
    l.show( 1999, 2005 );
    cout << "\n\nall triplets of ludic numbers < 250:" << "\n";
    l.findTriplets( 250 );
    cout << "\n\n";
    return system( "pause" );
}
