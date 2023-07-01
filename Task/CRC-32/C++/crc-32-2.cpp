#include <boost\crc.hpp>
#include <string>
#include <iostream>

int main()
{
    std::string str( "The quick brown fox jumps over the lazy dog" );
    boost::crc_32_type  crc;
    crc.process_bytes( str.data(), str.size() );

    std::cout << "Checksum: " << std::hex << crc.checksum() << std::endl;
    return 0;
}
