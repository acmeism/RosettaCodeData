int main ( int /*argc*/, char * * /*argv*/ )
{
 // Unused arguments should not be named
 // There are variations:
 // 1: main ''may'' explicitly return a value
 //    (other non-void-returning C++ functions ''must'' do so,
 //    but there's a special exception for main that falling off it
 //    without an explicit return is equivalent to a "return 0;" at
 //    the end of the main function)
 // 2: The arguments may be omitted entirely
}
