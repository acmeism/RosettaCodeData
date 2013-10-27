#include <string>
#include <iostream>
#include <algorithm>
#include <numeric>
#include <array>
#include <cstdint>

class CRC32
{
public:
    CRC32()
    {
        generateTable();
    }

    template<class T>
    uint32_t get( T begin, T end )
    {
        uint32_t nCRC = ~static_cast<uint32_t>(0);
        return ~std::accumulate( begin, end, 0xFFFFFFFF, [&](uint32_t nCRC, uint32_t nVal)
            { return (nCRC >> 8) ^ m_pTable[(nCRC & 0xff) ^ nVal]; } );
    }

private:
    void generateTable()
    {
        int nCount = 0;
        // fill the table with 0..255
        std::generate( m_pTable.begin(), m_pTable.end(), [&nCount](){ return nCount++; } );

        // calculate the crc table
        for (int j = 0; j < 8; j++)
        {
            std::transform( m_pTable.begin(), m_pTable.end(), m_pTable.begin(),
                [] ( uint32_t &nValue ) { return (nValue>>1)^((nValue&1)*0xedb88320); } );
        }
    }

private:
    std::array<uint32_t, 256> m_pTable;
};

int main()
{
    CRC32 oCrc;
    std::string str( "The quick brown fox jumps over the lazy dog" );
    std::cout << "Checksum: " << std::hex << oCrc.get( str.begin(), str.end() ) << std::endl;
    return 0;
}
