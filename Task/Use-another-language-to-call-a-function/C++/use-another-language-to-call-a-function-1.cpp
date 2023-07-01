#include <string>
using std::string;

// C++ functions with extern "C" can get called from C.
extern "C" int
Query (char *Data, size_t *Length)
{
   const string Message = "Here am I";

   // Check that Message fits in Data.
   if (*Length < Message.length())
      return false;  // C++ converts bool to int.

   *Length = Message.length();
   Message.copy(Data, *Length);
   return true;
}
