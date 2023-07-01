//compile with g++ main.cpp -lboost_system -pthread

#include <boost/asio.hpp>

int main()
{
  boost::asio::io_context io_context;
  boost::asio::ip::tcp::socket sock(io_context);
  boost::asio::ip::tcp::resolver resolver(io_context);
  boost::asio::ip::tcp::resolver::query query("localhost", "4321");

  boost::asio::connect(sock, resolver.resolve(query));
  boost::asio::write(sock, boost::asio::buffer("Hello world socket\r\n"));

  return 0;
}
