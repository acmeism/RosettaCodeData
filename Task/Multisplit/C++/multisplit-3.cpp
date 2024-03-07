/* multisplit.cpp */
#include <features.h>
#include <iostream>
#include <string>
#include <vector>
#include <format>

/* C++23 example for Multisplit  6 Jan 2024
 email:
      spikeysnack@gmail.com

 compile:
      g++-13 -std=c++23 -Wall -o multisplit multisplit.cpp
*/

// extra info
#define _EXTRA

// aliases
using std::string;
using std::vector;
using str_vec = vector<string>;
using std::cout;


// constants
constexpr static const size_t npos = -1;

// function signatures
string replace_all(string& str, string& remove, string& insert );

str_vec split_on_delim(string& str, const string& delims);

str_vec Multisplit( string& input, const str_vec& seps);

// functions

// replace all substrings in string
//     a = "dogs and cats and dogs and cats and birds"
//     replace(a, "cats" , "fish");
//        ==> "dogs and fish and dogs and fish and birds"

string replace_all(string& str,
		   const string& remove,
		   const string& insert ){
 string s{str};
 string::size_type pos = 0;

 #ifdef _EXTRA
   const string rightarrow{"\u2B62"}; //unicode arrow
   auto ex = std::format("match: {}\t{} ", remove, rightarrow);
   std::cerr << ex;
 #endif

 while ((pos = s.find(remove, pos)) != npos){
   s.replace(pos, remove.size(), insert);
   pos++;
 }

 return s;
}


// create a string vector from a string,
// split on a delimiter string
//    x = "ab:cde:fgh:ijk"
//   split_on_delim( x, ":");
//      ==> { "ab", "cde", "fgh", "ijk" }

str_vec split_on_delim(string& str, const string& delims) {
  string::size_type beg, pos = 0;
  str_vec sv;
  string tmp;

  while ( (beg = str.find_first_not_of(delims, pos)) != npos ){

    pos = str.find_first_of(delims, beg + 1);

    tmp = { str.substr(beg, pos - beg) };

    sv.push_back(tmp);
    }
  return sv;
}


str_vec Multisplit( string& input, const str_vec& seps) {

  string s1{input};
  str_vec sv;

  for( auto sep : seps){
      s1 = replace_all(s1, sep, "^"); // space sep

#ifdef _EXTRA
     std::cerr << s1 << "\n";
#endif
      sv = split_on_delim(s1, "^"); // split
    }
  return sv;
}


/* main program */

int main(){

  string sample{"a!===b=!=c"};

  const str_vec seps {"!=", "==", "="};

  auto s = std::format("sample: \t{}\n", sample);

  cout << s;

  auto sv = Multisplit(sample, seps);

  for( auto s : sv){
    auto out = std::format( "{}\t" , s);
    cout << out;
  }
  cout << "\n";

  return 0;
}

// end
