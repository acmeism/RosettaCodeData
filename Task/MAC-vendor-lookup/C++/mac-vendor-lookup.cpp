// This code is based on the example 'Simple HTTP Client' included with
// the Boost documentation.

#include <boost/beast/core.hpp>
#include <boost/beast/http.hpp>
#include <boost/beast/version.hpp>
#include <boost/asio/connect.hpp>
#include <boost/asio/ip/tcp.hpp>
#include <iostream>
#include <string>

bool get_mac_vendor(const std::string& mac, std::string& vendor) {
    namespace beast = boost::beast;
    namespace http = beast::http;
    namespace net = boost::asio;
    using tcp = net::ip::tcp;

    net::io_context ioc;
    tcp::resolver resolver(ioc);
    const char* host = "api.macvendors.com";

    beast::tcp_stream stream(ioc);
    stream.connect(resolver.resolve(host, "http"));

    http::request<http::string_body> req{http::verb::get, "/" + mac, 10};
    req.set(http::field::host, host);
    req.set(http::field::user_agent, BOOST_BEAST_VERSION_STRING);
    http::write(stream, req);

    beast::flat_buffer buffer;
    http::response<http::string_body> res;
    http::read(stream, buffer, res);

    bool success = res.result() == http::status::ok;
    if (success)
        vendor = res.body();

    beast::error_code ec;
    stream.socket().shutdown(tcp::socket::shutdown_both, ec);
    if (ec && ec != beast::errc::not_connected)
        throw beast::system_error{ec};

    return success;
}

int main(int argc, char** argv) {
    if (argc != 2 || strlen(argv[1]) == 0) {
        std::cerr << "usage: " << argv[0] << " MAC-address\n";
        return EXIT_FAILURE;
    }
    try {
        std::string vendor;
        if (get_mac_vendor(argv[1], vendor)) {
            std::cout << vendor << '\n';
            return EXIT_SUCCESS;
        } else {
            std::cout << "N/A\n";
        }
    } catch(std::exception const& e) {
        std::cerr << "Error: " << e.what() << std::endl;
    }
    return EXIT_FAILURE;
}
