#define BOOST_TEST_MAIN
#include <boost/test/unit_test.hpp>

BOOST_AUTO_TEST_CASE( Test1 )
{
    BOOST_CHECK( is_palindrome("ada") == true );
    BOOST_CHECK( is_palindrome("C++") == false );

    BOOST_CHECK( is_palindrome("ada") == false); // will fail
    BOOST_CHECK( is_palindrome("C++") == true);  // will fail
}
