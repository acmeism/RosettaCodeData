#include <bit>
#include <cstdint>
#include <iostream>
#include <sstream>
#include <stdexcept>
#include <string>
#include <vector>

class SHA256 {
public:
   std::string message_digest(const std::string& message) {
      std::vector<int64_t> hash = { 0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
                                   0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19 };

      const std::vector<int8_t> bytes = add_padding(message);
      for ( uint64_t i = 0; i < bytes.size() / BLOCK_LENGTH; ++i ) {
         std::vector<int32_t> words(BLOCK_LENGTH, 0);
         for ( int32_t j = 0; j < BLOCK_LENGTH; ++j ) {
            words[j / 4] |= ( bytes[i * BLOCK_LENGTH + j] & 0xff ) << ( ( 3 - j % 4 ) * 8 );
         }
         for ( int32_t j = 16; j < BLOCK_LENGTH; j++ ) {
            words[j] = sigma(3, words[j - 2]) + words[j - 7] + sigma(2, words[j - 15]) + words[j - 16];
         }

         int32_t a = hash[0], b = hash[1], c = hash[2], d = hash[3],
                e = hash[4], f = hash[5], g = hash[6], h = hash[7];

         for ( int32_t j = 0; j < BLOCK_LENGTH; ++j ) {
            int32_t t = h + sigma(1, e) + ch(e, f, g) + kk[j] + words[j];
            int32_t tt = sigma(0, a) + maj(a, b, c);
            h = g; g = f; f = e;
            e = d + t;
            d = c; c = b; b = a;
            a = t + tt;
         }

         hash[0] += a; hash[1] += b; hash[2] += c; hash[3] += d;
         hash[4] += e; hash[5] += f; hash[6] += g; hash[7] += h;
      }

      std::stringstream stream;
      for ( int32_t i = 0; i < BLOCK_LENGTH; ++i ) {
         int8_t byte_value = static_cast<int8_t>(hash[i / 8] >> ( 7 - i % 8 ) * 4);
         stream << std::hex << ( byte_value & 0xf );
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

   int32_t sigma(const uint32_t& group, const uint32_t& x) {
      int32_t result;
      switch ( group ) {
         case 0 : result = std::rotr(x,  2) ^ std::rotr(x, 13) ^ std::rotr(x, 22); break;
         case 1 : result = std::rotr(x,  6) ^ std::rotr(x, 11) ^ std::rotr(x, 25); break;
         case 2 : result = std::rotr(x,  7) ^ std::rotr(x, 18) ^ ( x >>  3 ); break;
         case 3 : result = std::rotr(x, 17) ^ std::rotr(x, 19) ^ ( x >> 10 ); break;
         default : throw std::invalid_argument("Unexpected argument for sigma: " + std::to_string(group));
      }
      return result;
   }

   int32_t ch(const int32_t& x, const int32_t y, const int32_t z) {
      return ( x & y ) ^ ( ~x & z );
   }

   int32_t maj(const int32_t& x, const int32_t y, const int32_t z) {
      return ( x & y ) ^ ( x & z ) ^ ( y & z );
   }

   const std::vector<int64_t> kk = {
      0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
        0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
        0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
        0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
        0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
        0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
        0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
        0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2 };

   const int32_t BLOCK_LENGTH = 64;
};

int main() {
   SHA256 sha256;
   std::cout << sha256.message_digest("Rosetta code") << std::endl;
}
