#include <iostream>
#include <vector>

// This class forms a simple 'generator', where operator() returns the next
// element in the series.  It uses a small sliding window buffer to minimize
// storage overhead.
class nacci_t
{
    std::vector< int >  history;
    unsigned            windex;             // sliding window index
    unsigned            rindex;             // result index
    int                 running_sum;        // sum of values in sliding window

  public:

    nacci_t( unsigned int order, int a0 = 1, int a1 = 1 )
    :   history( order + 1 ), windex( 0 ), rindex( order - 1 ),
        running_sum( a0 + a1 )
    {
        // intialize sliding window
        history[order - 1] = a0;
        history[order - 0] = a1;
    }

    int operator()()
    {
        int result   = history[ rindex ];   // get 'nacci number to return
        running_sum -= history[ windex ];   // old 'nacci falls out of window

        history[ windex ] = running_sum;    // new 'nacci enters the window
        running_sum      += running_sum;    // new 'nacci added to the sum

        if ( ++windex == history.size() ) windex = 0;
        if ( ++rindex == history.size() ) rindex = 0;

        return result;
    }
};

int main()
{
    for ( unsigned int i = 2; i <= 10; ++i )
    {
        nacci_t nacci( i ); // fibonacci sequence

        std::cout << "nacci( " << i << " ): ";

        for ( int j = 0; j < 10; ++j )
            std::cout << " " << nacci();

        std::cout << std::endl;
    }

    for ( unsigned int i = 2; i <= 10; ++i )
    {
        nacci_t lucas( i, 2, 1 ); // Lucas sequence

        std::cout << "lucas( " << i << " ): ";

        for ( int j = 0; j < 10; ++j )
            std::cout << " " << lucas();

        std::cout << std::endl;
    }
}
