#include <string>
#include <iomanip>
#include <iostream>

inline constexpr auto HEIGHT      = 16;
inline constexpr auto WIDTH       = 6;
inline constexpr auto ASCII_START = 32;
// ASCII special characters
inline constexpr auto SPACE  = 32;
inline constexpr auto DELETE = 127;

std::string displayAscii(char ascii) {
    switch (ascii) {
        case SPACE: return "Spc";
        case DELETE: return "Del";
        default: return std::string(1, ascii);
    }
}

int main() {
    for (std::size_t row = 0; row < HEIGHT; ++row) {
        for (std::size_t col = 0; col < WIDTH; ++col) {
            const auto ascii = ASCII_START + row + col * HEIGHT;
            std::cout << std::right << std::setw(3) << ascii << " : " << std::left << std::setw(6) << displayAscii(ascii);
        }
        std::cout << '\n';
    }
}
