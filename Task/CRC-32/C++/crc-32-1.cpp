#include <array>
#include <ranges>
#include <cstdint>
#include <numeric>
#include <concepts>
#include <algorithm>

// These headers are only needed for main(), to demonstrate.
#include <iomanip>
#include <iostream>
#include <string_view>

inline constexpr auto crc_table = []() {
    std::array<std::uint32_t, 256> retval{};
    std::generate(retval.begin(), retval.end(),
        [n = std::uint32_t{ 0 }]() mutable {
            auto c = n++;
            for (std::uint8_t k = 0; k < 8; ++k) {
                if (c & 1) c = std::uint32_t{ 0xedb88320 } ^ (c >> 1);
                else c >>= 1;
            }
            return c;
        });
    return retval;
}();


[[nodiscard]] constexpr std::uint32_t crc(const std::ranges::input_range auto& rng)
noexcept requires std::convertible_to<std::ranges::range_value_t<decltype(rng)>, std::uint8_t> {
  return ~std::accumulate(std::ranges::begin(rng), std::ranges::end(rng),
      ~std::uint32_t{ 0 } & std::uint32_t{ 0xff'ff'ff'ffu },
        [](std::uint32_t checksum, std::uint8_t value)
          { return crc_table[(checksum ^ value) & 0xff] ^ (checksum >> 8); });
}

int main() {
  constexpr std::string_view str = "The quick brown fox jumps over the lazy dog";

  std::cout << std::hex << std::setw(8) << std::setfill('0') << crc(str) << '\n';
}
