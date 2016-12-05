#include <boost/asio.hpp>
#include <iostream>

int main() {
  int rc {EXIT_SUCCESS};
  try {
    boost::asio::io_service io_service;
    boost::asio::ip::tcp::resolver resolver {io_service};
    auto entries = resolver.resolve({"www.kame.net", ""});
    boost::asio::ip::tcp::resolver::iterator entries_end;
    for (; entries != entries_end; ++entries) {
      std::cout << entries->endpoint().address() << std::endl;
    }
  }
  catch (std::exception& e) {
    std::cerr << e.what() << std::endl;
    rc = EXIT_FAILURE;
  }
  return rc;
}
