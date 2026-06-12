#include <iostream>
#include <fstream>
#include <vector>

typedef unsigned char byte;
using namespace std;

const unsigned m1 = 63 << 18, m2 = 63 << 12, m3 = 63 << 6;

class base64
{
public:
    base64() { char_set = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"; }
    string encode( vector<byte> v )
    {
  string res;
  unsigned d, a = 0, l = static_cast<unsigned>( v.size() );
  while( l > 2 )
  {
      d = v[a++] << 16 | v[a++] << 8 | v[a++];
      res.append( 1, char_set.at( ( d & m1 ) >> 18 ) );
      res.append( 1, char_set.at( ( d & m2 ) >> 12 ) );
      res.append( 1, char_set.at( ( d & m3 ) >>  6 ) );
      res.append( 1, char_set.at( d & 63 ) );
      l -= 3;
  }
  if( l == 2 )
  {
      d = v[a++] << 16 | v[a++] << 8;
      res.append( 1, char_set.at( ( d & m1 ) >> 18 ) );
      res.append( 1, char_set.at( ( d & m2 ) >> 12 ) );
      res.append( 1, char_set.at( ( d & m3 ) >>  6 ) );
      res.append( 1, '=' );
  }
  else if( l == 1 )
  {
      d = v[a++] << 16;
      res.append( 1, char_set.at( ( d & m1 ) >> 18 ) );
      res.append( 1, char_set.at( ( d & m2 ) >> 12 ) );
      res.append( "==", 2 );
  }
  return res;
    }

private:
    string char_set;
};

int main( int argc, char* argv[] )
{
    base64 b;
    basic_ifstream<byte> f( "favicon.ico", ios::binary );
    string r = b.encode( vector<byte>( ( istreambuf_iterator<byte>( f ) ), istreambuf_iterator<byte>() ) );
    copy( r.begin(), r.end(), ostream_iterator<char>( cout ) );
    return 0;
}
