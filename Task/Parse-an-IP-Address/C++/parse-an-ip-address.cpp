#include <boost/asio/ip/address.hpp>
#include <cstdint>
#include <iostream>
#include <iomanip>
#include <limits>
#include <string>

using boost::asio::ip::address;
using boost::asio::ip::address_v4;
using boost::asio::ip::address_v6;
using boost::asio::ip::make_address;
using boost::asio::ip::make_address_v4;
using boost::asio::ip::make_address_v6;

template<typename uint>
bool parse_int(const std::string& str, int base, uint& n)
{
    try
    {
        size_t pos = 0;
        unsigned long u = stoul(str, &pos, base);
        if (pos != str.length() || u > std::numeric_limits<uint>::max())
            return false;
        n = static_cast<uint>(u);
        return true;
    }
    catch (const std::exception& ex)
    {
        return false;
    }
}

//
// Parse an IP address and port from the given input string.
//
// Throws an exception if the input is not valid.
//
// Valid formats are:
// [ipv6_address]:port
// ipv4_address:port
// ipv4_address
// ipv6_address
//
void parse_ip_address_and_port(const std::string& input, address& addr, uint16_t& port)
{
    size_t pos = input.rfind(':');
    if (pos != std::string::npos && pos > 1 && pos + 1 < input.length()
        && parse_int(input.substr(pos + 1), 10, port) && port > 0)
    {
        if (input[0] == '[' && input[pos - 1] == ']')
        {
            // square brackets so can only be an IPv6 address
            addr = make_address_v6(input.substr(1, pos - 2));
            return;
        }
        else
        {
            try
            {
                // IPv4 address + port?
                addr = make_address_v4(input.substr(0, pos));
                return;
            }
            catch (const std::exception& ex)
            {
                // nope, might be an IPv6 address
            }
        }
    }
    port = 0;
    addr = make_address(input);
}

void print_address_and_port(const address& addr, uint16_t port)
{
    std::cout << std::hex << std::uppercase << std::setfill('0');
    if (addr.is_v4())
    {
        address_v4 addr4 = addr.to_v4();
        std::cout << "address family: IPv4\n";
        std::cout << "address number: " << std::setw(8) << addr4.to_uint() << '\n';
    }
    else if (addr.is_v6())
    {
        address_v6 addr6 = addr.to_v6();
        address_v6::bytes_type bytes(addr6.to_bytes());
        std::cout << "address family: IPv6\n";
        std::cout << "address number: ";
        for (unsigned char byte : bytes)
            std::cout << std::setw(2) << static_cast<unsigned int>(byte);
        std::cout << '\n';
    }
    if (port != 0)
        std::cout << "port: " << std::dec << port << '\n';
    else
        std::cout << "port not specified\n";
}

void test(const std::string& input)
{
    std::cout << "input: " << input << '\n';
    try
    {
        address addr;
        uint16_t port = 0;
        parse_ip_address_and_port(input, addr, port);
        print_address_and_port(addr, port);
    }
    catch (const std::exception& ex)
    {
        std::cout << "parsing failed\n";
    }
    std::cout << '\n';
}

int main(int argc, char** argv)
{
    test("127.0.0.1");
    test("127.0.0.1:80");
    test("::ffff:127.0.0.1");
    test("::1");
    test("[::1]:80");
    test("1::80");
    test("2605:2700:0:3::4713:93e3");
    test("[2605:2700:0:3::4713:93e3]:80");
    return 0;
}
