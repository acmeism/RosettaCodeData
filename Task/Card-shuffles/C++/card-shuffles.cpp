#include <time.h>
#include <algorithm>
#include <iostream>
#include <string>
#include <deque>


class riffle
{
public:
    void shuffle( std::deque<int>* v, int tm )
    {
        std::deque<int> tmp;
  bool fl;
  size_t len;
  std::deque<int>::iterator it;

  copyTo( v, &tmp );

  for( int t = 0; t < tm; t++ )
  {
      std::deque<int> lHand( rand() % ( tmp.size() / 3 ) + ( tmp.size() >> 1 ) ), rHand( tmp.size() - lHand.size() );

      std::copy( tmp.begin(), tmp.begin() + lHand.size(), lHand.begin() );
      std::copy( tmp.begin() + lHand.size(), tmp.end(), rHand.begin() );
      tmp.clear();

      while( lHand.size() && rHand.size() )
      {
    fl = rand() % 10 < 5;
    if( fl )
            len = 1 + lHand.size() > 3 ? rand() % 3 + 1 : rand() % ( lHand.size() ) + 1;
    else
        len = 1 + rHand.size() > 3 ? rand() % 3 + 1 : rand() % ( rHand.size() ) + 1;

    while( len )
    {
        if( fl )
        {
      tmp.push_front( *lHand.begin() );
      lHand.erase( lHand.begin() );
        }
        else
        {
      tmp.push_front( *rHand.begin() );
      rHand.erase( rHand.begin() );
        }
        len--;
    }
      }

      if( lHand.size() < 1 )
      {
    for( std::deque<int>::iterator x = rHand.begin(); x != rHand.end(); x++ )
        tmp.push_front( *x );
      }
      if( rHand.size() < 1 )
      {
    for( std::deque<int>::iterator x = lHand.begin(); x != lHand.end(); x++ )
        tmp.push_front( *x );
      }
  }
  copyTo( &tmp, v );
    }
private:
    void copyTo( std::deque<int>* a, std::deque<int>* b )
    {
  for( std::deque<int>::iterator x = a->begin(); x != a->end(); x++ )
      b->push_back( *x );
  a->clear();
    }
};

class overhand
{
public:
    void shuffle( std::deque<int>* v, int tm )
    {
  std::deque<int> tmp;
  bool top;
  for( int t = 0; t < tm; t++ )
  {
      while( v->size() )
      {
    size_t len = rand() % ( v->size() ) + 1;
    top = rand() % 10 < 5;
    while( len )
    {
        if( top ) tmp.push_back( *v->begin() );
        else tmp.push_front( *v->begin() );
        v->erase( v->begin() );
        len--;
    }
      }
      for( std::deque<int>::iterator x = tmp.begin(); x != tmp.end(); x++ )
    v->push_back( *x );

      tmp.clear();
  }
    }
};

// global - just to make things simpler ---------------------------------------------------
std::deque<int> cards;

void fill()
{
    cards.clear();
    for( int x = 0; x < 20; x++ )
  cards.push_back( x + 1 );
}

void display( std::string t )
{
    std::cout << t << "\n";
    for( std::deque<int>::iterator x = cards.begin(); x != cards.end(); x++ )
  std::cout << *x << " ";
    std::cout << "\n\n";
}

int main( int argc, char* argv[] )
{
    srand( static_cast<unsigned>( time( NULL ) ) );
    riffle r; overhand o;

    fill(); r.shuffle( &cards, 10 ); display( "RIFFLE" );
    fill(); o.shuffle( &cards, 10 ); display( "OVERHAND" );
    fill(); std::random_shuffle( cards.begin(), cards.end() ); display( "STD SHUFFLE" );

    return 0;
}
