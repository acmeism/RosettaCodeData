#include <iostream>
#include <string>
#include <cstdlib>
#include <boost/mpl/string.hpp>
#include <boost/mpl/fold.hpp>
#include <boost/mpl/size_t.hpp>

using namespace std;
using namespace boost;

///////////////////////////////////////////////////////////////////////////////
// exponentiation calculations
template <int accum, int base, int exp> struct POWER_CORE : POWER_CORE<accum * base, base, exp - 1>{};

template <int accum, int base>
struct POWER_CORE<accum, base, 0>
{
    enum : int { val = accum };
};

template <int base, int exp> struct POWER : POWER_CORE<1, base, exp>{};

///////////////////////////////////////////////////////////////////////////////
// # of digit calculations
template <int depth, unsigned int i> struct NUM_DIGITS_CORE : NUM_DIGITS_CORE<depth + 1, i / 10>{};

template <int depth>
struct NUM_DIGITS_CORE<depth, 0>
{
    enum : int { val = depth};
};

template <int i> struct NUM_DIGITS : NUM_DIGITS_CORE<0, i>{};

template <>
struct NUM_DIGITS<0>
{
    enum : int { val = 1 };
};

///////////////////////////////////////////////////////////////////////////////
// Convert digit to character (1 -> '1')
template <int i>
struct DIGIT_TO_CHAR
{
    enum : char{ val = i + 48 };
};

///////////////////////////////////////////////////////////////////////////////
// Find the digit at a given offset into a number of the form 0000000017
template <unsigned int i, int place> // place -> [0 .. 10]
struct DIGIT_AT
{
    enum : char{ val = (i / POWER<10, place>::val) % 10 };
};

struct NULL_CHAR
{
    enum : char{ val = '\0' };
};

///////////////////////////////////////////////////////////////////////////////
// Convert the digit at a given offset into a number of the form '0000000017' to a character
template <unsigned int i, int place> // place -> [0 .. 9]
    struct ALT_CHAR : DIGIT_TO_CHAR< DIGIT_AT<i, place>::val >{};

///////////////////////////////////////////////////////////////////////////////
// Convert the digit at a given offset into a number of the form '17' to a character

// Template description, with specialization to generate null characters for out of range offsets
template <unsigned int i, int offset, int numDigits, bool inRange>
    struct OFFSET_CHAR_CORE_CHECKED{};
template <unsigned int i, int offset, int numDigits>
    struct OFFSET_CHAR_CORE_CHECKED<i, offset, numDigits, false> : NULL_CHAR{};
template <unsigned int i, int offset, int numDigits>
    struct OFFSET_CHAR_CORE_CHECKED<i, offset, numDigits, true>  : ALT_CHAR<i, (numDigits - offset) - 1 >{};

// Perform the range check and pass it on
template <unsigned int i, int offset, int numDigits>
    struct OFFSET_CHAR_CORE : OFFSET_CHAR_CORE_CHECKED<i, offset, numDigits, offset < numDigits>{};

// Calc the number of digits and pass it on
template <unsigned int i, int offset>
    struct OFFSET_CHAR : OFFSET_CHAR_CORE<i, offset, NUM_DIGITS<i>::val>{};

///////////////////////////////////////////////////////////////////////////////
// Integer to char* template. Works on unsigned ints.
template <unsigned int i>
struct IntToStr
{
    const static char str[];
    typedef typename mpl::string<
    OFFSET_CHAR<i, 0>::val,
    OFFSET_CHAR<i, 1>::val,
    OFFSET_CHAR<i, 2>::val,
    OFFSET_CHAR<i, 3>::val,
    OFFSET_CHAR<i, 4>::val,
    OFFSET_CHAR<i, 5>::val,
    /*OFFSET_CHAR<i, 6>::val,
    OFFSET_CHAR<i, 7>::val,
    OFFSET_CHAR<i, 8>::val,
    OFFSET_CHAR<i, 9>::val,*/
    NULL_CHAR::val>::type type;
};

template <unsigned int i>
const char IntToStr<i>::str[] =
{
    OFFSET_CHAR<i, 0>::val,
    OFFSET_CHAR<i, 1>::val,
    OFFSET_CHAR<i, 2>::val,
    OFFSET_CHAR<i, 3>::val,
    OFFSET_CHAR<i, 4>::val,
    OFFSET_CHAR<i, 5>::val,
    OFFSET_CHAR<i, 6>::val,
    OFFSET_CHAR<i, 7>::val,
    OFFSET_CHAR<i, 8>::val,
    OFFSET_CHAR<i, 9>::val,
    NULL_CHAR::val
};

template <bool condition, class Then, class Else>
struct IF
{
    typedef Then RET;
};

template <class Then, class Else>
struct IF<false, Then, Else>
{
    typedef Else RET;
};


template < typename Str1, typename Str2 >
struct concat : mpl::insert_range<Str1, typename mpl::end<Str1>::type, Str2> {};
template <typename Str1, typename Str2, typename Str3 >
struct concat3 : mpl::insert_range<Str1, typename mpl::end<Str1>::type, typename concat<Str2, Str3 >::type > {};

typedef typename mpl::string<'f','i','z','z'>::type fizz;
typedef typename mpl::string<'b','u','z','z'>::type buzz;
typedef typename mpl::string<'\r', '\n'>::type mpendl;
typedef typename concat<fizz, buzz>::type fizzbuzz;

// discovered boost mpl limitation on some length

template <int N>
struct FizzBuzz
{
    typedef typename concat3<typename FizzBuzz<N - 1>::type, typename IF<N % 15 == 0, typename fizzbuzz::type, typename IF<N % 3 == 0, typename fizz::type, typename IF<N % 5 == 0, typename buzz::type, typename IntToStr<N>::type >::RET >::RET >::RET, typename mpendl::type>::type type;
};

template <>
struct FizzBuzz<1>
{
    typedef mpl::string<'1','\r','\n'>::type type;
};

int main(int argc, char** argv)
{
    const int n = 7;
    std::cout << mpl::c_str<FizzBuzz<n>::type>::value << std::endl;
	return 0;
}
