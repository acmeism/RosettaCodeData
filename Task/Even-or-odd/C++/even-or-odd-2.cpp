template < typename T >
constexpr inline bool isEven( const T& v )
{
    return isEven( int( v ) );
}

template <>
constexpr inline bool isEven< int >( const int& v )
{
    return (v & 1) == 0;
}

template < typename T >
constexpr inline bool isOdd( const T& v )
{
    return !isEven(v);
}
