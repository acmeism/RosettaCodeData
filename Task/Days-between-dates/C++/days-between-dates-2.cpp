#include <cstdlib>
#include <iostream>
#include <boost/date_time/gregorian/gregorian.hpp>

int main(int argc, char** argv) {
    using namespace boost::gregorian;
    if (argc != 3) {
        std::cerr << "usage: " << argv[0] << " start-date end-date\n";
        return EXIT_FAILURE;
    }
    try {
        date start_date(from_simple_string(argv[1]));
        date end_date(from_simple_string(argv[2]));
        std::cout << end_date - start_date << '\n';
    } catch (const std::exception& ex) {
        std::cerr << ex.what() << '\n';
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}
