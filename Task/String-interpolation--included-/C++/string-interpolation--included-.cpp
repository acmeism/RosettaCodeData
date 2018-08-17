// Variable argument template

#include <string>
#include <vector>

using std::string;
using std::vector;

template<typename S, typename... Args>
string interpolate( const S& orig , const Args&... args)
{
   string out(orig);

   // populate vector from argument list
   auto va = {args...};
   vector<string> v{va};

   size_t i = 1;

   for( string s: v)
     {
       string is = std::to_string(i);
       string t = "{" +  is + "}";  // "{1}", "{2}", ...
       try
	 {
	   auto pos = out.find(t);

	   if ( pos != out.npos)  // found token
	     {
	       out.erase(pos, t.length()); //erase token
	       out.insert( pos, s);       // insert arg
	     }

	   i++;                           // next
	 }
	 catch( std::exception& e)
	   {
	     std::cerr << e.what() << std::endl;
	   }

     } // for

   return out;
}
