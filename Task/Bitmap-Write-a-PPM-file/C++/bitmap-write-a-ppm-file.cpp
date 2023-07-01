#include <fstream>

int main() {
    constexpr auto dimx = 800u, dimy = 800u;

    std::ofstream ofs("first.ppm", ios_base::out | ios_base::binary);
    ofs << "P6\n" << dimx << ' ' << dimy << "\n255\n";

    for (auto j = 0u; j < dimy; ++j)
        for (auto i = 0u; i < dimx; ++i)
            ofs << static_cast<char>(i % 256)
                << static_cast<char>(j % 256)
                << static_cast<char>((i * j) % 256);
}
