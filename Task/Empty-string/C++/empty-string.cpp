#include <string>

// ...


                     // empty string declaration
std::string str;     // (default constructed)
std::string str();   // (default constructor, no parameters)
std::string str{};   // (default initialized)
std::string str(""); // (const char[] conversion)
std::string str{""}; // (const char[] initializer list)



if (str.empty()) { ... } // to test if string is empty

// we could also use the following
if (str.length() == 0) { ... }
if (str == "") { ... }

// make a std::string empty
str.clear();          // (builtin clear function)
str = "";             // replace contents with empty string
str = {};             // swap contents with temp string (empty),then destruct temp

                       // swap with empty string
std::string tmp{};     // temp empty string
str.swap(tmp);         // (builtin swap function)
std::swap(str, tmp);   // swap contents with tmp


// create an array of empty strings
std::string  s_array[100];           // 100 initialized to "" (fixed size)
std::array<std::string, 100>  arr;   // 100 initialized to "" (fixed size)
std::vector<std::string>(100,"");    // 100 initialized to "" (variable size, 100 starting size)

// create empty string as default parameter
void func( std::string& s = {} ); // {} generated default std:string instance
