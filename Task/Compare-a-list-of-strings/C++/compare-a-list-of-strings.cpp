#include <algorithm>
#include <string>

// Bug: calling operator++ on an empty collection invokes undefined behavior.
std::all_of( ++(strings.begin()), strings.end(),
             [&](std::string a){ return a == strings.front(); } )  // All equal

std::is_sorted( strings.begin(), strings.end(),
                [](std::string a, std::string b){ return !(b < a); }) )  // Strictly ascending
