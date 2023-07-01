/* caesar cipher */

#include <string>
#include <iostream>
#include <cctype>

int main( ) {

  using namespace std;

  string input ;
  int key = 0;

  // lambda functions

  auto encrypt = [&](char c, int key ) {
    char A  = ( islower(c) )? 'a': 'A';
    c = (isalpha(c))? (c - A + key) % 26 + A : c;
    return (char) c;
  };

  auto decrypt = [&](char c, int key ) {
    char A  = ( islower(c) )? 'a': 'A';
    c = (isalpha(c))? (c - A + (26 - key) ) % 26 + A : c;
    return (char) c;
  };


  cout << "Enter a line of text.\n";
  getline( cin , input );

  cout << "Enter an integer to shift text.\n";
  cin  >> key;

  while ( (key < 1) || (key > 25) )
    {
      cout << "must be an integer between 1 and 25 -->" << endl;
      cin  >> key;
    }

  cout << "Plain:    \t" << input << endl ;

  for ( auto & cp : input)    // use & for mutability
      cp = encrypt(cp, key);

  cout << "Encrypted:\t" << input << endl;

  for ( auto & cp : input)
      cp = decrypt(cp, key);

  cout << "Decrypted:\t" << input << endl;

  return 0 ;
}
