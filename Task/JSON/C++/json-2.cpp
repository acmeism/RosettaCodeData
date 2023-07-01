#include <iostream>
#include <iomanip> // std::setw
#include <sstream>
#include <cassert>

#include "json.hpp"

using json = nlohmann::json;

int main( int argc, char* argv[] )
{
        std::string const expected =
R"delim123({
    "answer": {
        "everything": 42
    },
    "happy": true,
    "list": [
        1,
        0,
        2
    ],
    "name": "Niels",
    "nothing": null,
    "object": {
        "currency": "USD",
        "value": 42.99
    },
    "pi": 3.141
})delim123";

    json const jexpected = json::parse( expected );

    assert( jexpected["list"][1].get<int>() == 0 );
    assert( jexpected["object"]["currency"] == "USD" );

    json jhandmade = {
        {"pi", 3.141},
        {"happy", true},
        {"name", "Niels"},
        {"nothing", nullptr},
        {"answer", {
             {"everything", 42}
         }
        },
        {"list", {1, 0, 2}},
        {"object", {
             {"currency", "USD"},
             {"value", 42.99}
         }
        }
    };

    assert( jexpected == jhandmade );

    std::stringstream jhandmade_stream;
    jhandmade_stream << std::setw(4) << jhandmade;

    std::string jhandmade_string = jhandmade.dump(4);

    assert( jhandmade_string == expected );
    assert( jhandmade_stream.str() == expected );

    return 0;
}
