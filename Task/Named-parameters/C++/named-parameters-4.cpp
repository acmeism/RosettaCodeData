#include <boost/parameter/name.hpp>
#include <boost/parameter/preprocessor.hpp>
#include <string>

BOOST_PARAMETER_NAME(foo)
BOOST_PARAMETER_NAME(bar)
BOOST_PARAMETER_NAME(baz)
BOOST_PARAMETER_NAME(bonk)

BOOST_PARAMETER_FUNCTION(
    (int),  // the return type of the function, the parentheses are required.
    function_with_named_parameters, // the name of the function.
    tag,  // part of the deep magic. If you use BOOST_PARAMETER_NAME you need to put "tag" here.
    (required // names and types of all required parameters, parentheses are required.
        (foo, (int))
        (bar, (float))
    )
    (optional // names, types, and default values of all optional parameters.
        (baz, (bool) , false)
        (bonk, (std::string), "default value")
    )
)
{
    if (baz && (bar > 1.0)) return foo;
    return bonk.size();
}
