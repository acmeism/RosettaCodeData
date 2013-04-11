#include <iostream>
#include <boost/date_time.hpp>
int main()
{
    std::cout << boost::posix_time::ptime( boost::posix_time::min_date_time ) << '\n';
    return 0;
}
