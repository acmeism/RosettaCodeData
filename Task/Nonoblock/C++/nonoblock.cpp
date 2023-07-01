#include <iomanip>
#include <iostream>
#include <algorithm>
#include <numeric>
#include <string>
#include <vector>

typedef std::pair<int, std::vector<int> > puzzle;

class nonoblock {
public:
    void solve( std::vector<puzzle>& p ) {
        for( std::vector<puzzle>::iterator i = p.begin(); i != p.end(); i++ ) {
            counter = 0;
            std::cout << " Puzzle: " << ( *i ).first << " cells and blocks [ ";
            for( std::vector<int>::iterator it = ( *i ).second.begin(); it != ( *i ).second.end(); it++ )
                std::cout << *it << " ";
            std::cout << "] ";
            int s = std::accumulate( ( *i ).second.begin(), ( *i ).second.end(), 0 ) + ( ( *i ).second.size() > 0 ? ( *i ).second.size() - 1 : 0 );
            if( ( *i ).first - s < 0 ) {
                std::cout << "has no solution!\n\n\n";
                continue;
            }
            std::cout << "\n Possible configurations:\n\n";
            std::string b( ( *i ).first, '-' );
            solve( *i, b, 0 );
            std::cout << "\n\n";
        }
    }

private:
    void solve( puzzle p, std::string n, int start ) {
        if( p.second.size() < 1 ) {
            output( n );
            return;
        }
        std::string temp_string;
        int offset,
            this_block_size = p.second[0];

        int space_need_for_others = std::accumulate( p.second.begin() + 1, p.second.end(), 0 );
        space_need_for_others += p.second.size() - 1;

        int space_for_curr_block = p.first - space_need_for_others - std::accumulate( p.second.begin(), p.second.begin(), 0 );

        std::vector<int> v1( p.second.size() - 1 );
        std::copy( p.second.begin() + 1, p.second.end(), v1.begin() );
        puzzle p1 = std::make_pair( space_need_for_others, v1 );

        for( int a = 0; a < space_for_curr_block; a++ ) {
            temp_string = n;

            if( start + this_block_size > n.length() ) return;

            for( offset = start; offset < start + this_block_size; offset++ )
                temp_string.at( offset ) = 'o';

            if( p1.first ) solve( p1, temp_string, offset + 1 );
            else output( temp_string );

            start++;
        }
    }
    void output( std::string s ) {
        char b = 65 - ( s.at( 0 ) == '-' ? 1 : 0 );
        bool f = false;
        std::cout << std::setw( 3 ) << ++counter << "\t|";
        for( std::string::iterator i = s.begin(); i != s.end(); i++ ) {
            b += ( *i ) == 'o' && f ? 1 : 0;
            std::cout << ( ( *i ) == 'o' ? b : '_' ) << "|";
            f = ( *i ) == '-' ? true : false;
        }
        std::cout << "\n";
    }

    unsigned counter;
};

int main( int argc, char* argv[] )
{
    std::vector<puzzle> problems;
    std::vector<int> blocks;
    blocks.push_back( 2 ); blocks.push_back( 1 );
    problems.push_back( std::make_pair( 5, blocks ) );
    blocks.clear();
    problems.push_back( std::make_pair( 5, blocks ) );
    blocks.push_back( 8 );
    problems.push_back( std::make_pair( 10, blocks ) );
    blocks.clear();
    blocks.push_back( 2 ); blocks.push_back( 3 );
    problems.push_back( std::make_pair( 5, blocks ) );
    blocks.push_back( 2 ); blocks.push_back( 3 );
    problems.push_back( std::make_pair( 15, blocks ) );

    nonoblock nn;
    nn.solve( problems );

    return 0;
}
