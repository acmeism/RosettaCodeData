#include <bit>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

class SHA1 {
public:
   std::string message_digest(const std::string& message) {
      std::vector<uint32_t> state = { 0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476, 0xc3d2e1f0 };

      const std::vector<int8_t> bytes = add_padding(message);
      for ( uint64_t i = 0; i < bytes.size() / BLOCK_LENGTH; ++i ) {
         std::vector<uint32_t> values(80, 0);
         for ( uint32_t j = 0; j < BLOCK_LENGTH; ++j ) {
            values[j / 4] |= ( bytes[i * BLOCK_LENGTH + j] & 0xff ) << ( ( 3 - j % 4 ) * 8 );
         }
         for ( uint32_t j = 16; j < 80; ++j ) {
            uint32_t value = values[j - 3] ^ values[j - 8] ^ values[j - 14] ^ values[j - 16];
            values[j] = std::rotl(value, 1);
         }

         uint32_t a = state[0], b = state[1], c = state[2], d = state[3], e = state[4];
         uint32_t f = 0, k = 0;
         for ( uint32_t j = 0; j < 80; ++j ) {
            switch ( j / 20 ) {
               case 0 : { f = ( b & c ) | ( ~b & d );            k = 0x5a827999; break; }
               case 1 : { f = b ^ c ^ d;                         k = 0x6ed9eba1; break; }
               case 2 : { f = ( b & c ) | ( b & d ) | ( c & d ); k = 0x8f1bbcdc; break; }
               case 3 : { f = b ^ c ^ d;                         k = 0xca62c1d6; break; }
            }

            uint32_t temp = std::rotl(a, 5) + f + e + k + values[j];
            e = d; d = c; c = std::rotl(b, 30); b = a; a = temp;
         }

         state[0] += a; state[1] += b; state[2] += c; state[3] += d; state[4] += e;
      }

      std::stringstream stream;
      for ( uint32_t i = 0; i < 20; ++i ) {
         int8_t byte_value = static_cast<int8_t>(state[i / 4] >> ( 24 - ( i % 4 ) * 8));
         stream << std::setfill('0') << std::setw(2) << std::hex << ( byte_value & 0xff );
      }
      return stream.str();
   }

private:
   std::vector<int8_t> add_padding(const std::string& message) {
      std::vector<int8_t> bytes(message.begin(), message.end());
      bytes.emplace_back(static_cast<uint8_t>(0x80));

      uint32_t padding = BLOCK_LENGTH - ( bytes.size() % BLOCK_LENGTH );
      if ( padding < 8 ) {
         padding += BLOCK_LENGTH;
      }
      bytes.resize(bytes.size() + padding - 8, static_cast<int8_t>(0x0));

      const uint64_t bit_length = 8 * message.length();
      for ( int32_t i = 7; i >= 0; --i ) {
         bytes.emplace_back(static_cast<int8_t>(bit_length >> ( 8 * i )));
      }
      return bytes;
   }

   const uint32_t BLOCK_LENGTH = 64;
};

int main() {
   SHA1 sha1;
   std::cout << sha1.message_digest("Rosetta Code") << std::endl;
}
