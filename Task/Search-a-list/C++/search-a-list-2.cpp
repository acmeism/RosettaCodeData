/* new c++-11 features
 * list class
 * initialization strings
 * auto typing
 * lambda functions
 * noexcept
 * find
 * for/in loop
 */

#include <iostream>   // std::cout, std::endl
#include <algorithm>  // std::find
#include <list>       // std::list
#include <vector>     // std::vector
#include <string>     // string::basic_string


using namespace std;     // saves typing of "std::" before everything

int main()
{

  // initialization lists
  // create objects and fully initialize them with given values

  list<string> l { "Zig", "Zag", "Wally", "Homer", "Madge",
                   "Watson", "Ronald", "Bush", "Krusty", "Charlie",
                   "Bush", "Bush", "Boz", "Zag" };

  list<string> n { "Bush" , "Obama", "Homer",  "Sherlock" };


  //  lambda function with auto typing
  //  auto is easier to write than looking up the compicated
  //  specialized iterator type that is actually returned.
  //  Just know that it returns an iterator for the list at the position found,
  //  or throws an exception if s in not in the list.
  //  runtime_error is used because it can be initialized with a message string.

  auto contains = [](list<string> l, string s) throw(runtime_error)
    {
      auto r = find(begin(l), end(l), s );

      if ( r == end(l) ) throw runtime_error( s + " not found" );

      return r;
    };


  // returns an int vector with the indexes of the search string
  // The & is a "default capture" meaning that it "allows in"
  // the variables that are in scope where it is called by their
  // name to simplify things.

  auto index = [&](list<string> l, string s) noexcept
    {
      vector<int> index_v;

      int idx = 0;

      for(auto& r : l)
	{
	  if ( s.compare(r) == 0 ) index_v.push_back(idx); // match -- add to vector
	  idx++;
	}

      // even though index_v is local to the lambda function,
      // c++11 move semantics does what you want and returns it
      // live and intact instead of destroying it or returning a copy.
      // (very efficient for large objects!)
      return index_v;
    };



  // for/in loop
  for (const string& s : n) // new iteration syntax is simple and intuitive
    {
      try
	{
	
	  auto cont = contains( l , s); // checks if there is any match
	
	  vector<int> vf = index( l, s );

	  cout << "l contains: " << s <<  " at " ;

	  for (auto x : vf)
	    { cout << x << " "; }   // if vector is empty this doesn't run

	  cout << endl ;	

      }
      catch (const runtime_error& r)  // string not found
	{
	  cout << r.what() << endl;
	  continue;                   // try next string
	}
    } //for


  return 0;

} // main

/* end */
