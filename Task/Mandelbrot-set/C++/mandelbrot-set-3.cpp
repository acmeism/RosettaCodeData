/*
 * Mandelbrot Set High-Fidelity Renderer
 *
 * Key Features:
 * - 80-bit Extended Precision (long double)
 * - 8x8 Super-Sampling Anti-Aliasing (64 samples per pixel)
 * - OpenMP Parallel Processing
 * - Direct RGB-Space Integration (24-bit TrueColor)
 *
 * Original project and full source code:
 * https://github.com/Divetoxx/Mandelbrot
 */

#include <iostream>
#include <fstream>
#include <vector>
#include <cmath>
#include <cstdint>
#include <atomic>
#include <omp.h>
using namespace std;
const double PI = 3.14159265358979323846;
#pragma pack(push, 1)
struct BMPHeader {
    uint16_t type{0x4D42};
    uint32_t size{0};
    uint16_t reserved1{0};
    uint16_t reserved2{0};
    uint32_t offBits{54};
    uint32_t structSize{40};
    int32_t  width{0};
    int32_t  height{0};
    uint16_t planes{1};
    uint16_t bitCount{24};
    uint32_t compression{0};
    uint32_t sizeImage{0};
    int32_t  xpelsPerMeter{2834};
    int32_t  ypelsPerMeter{2834};
    uint32_t clrUsed{0};
    uint32_t clrImportant{0};
};
#pragma pack(pop)
int main() {
    long double absc, ordi, size_val;
    absc = -1.39966699645936; ordi = 0.0005429083913; size_val = 0.000000000000036;
    const int horiz = 1920;
    const int vert = 1920;
    const int rowSize = (horiz * 3 + 3) & ~3;
    BMPHeader h;
    h.width = horiz;
    h.height = vert;
    h.sizeImage = rowSize * vert;
    h.size = h.sizeImage + 54;
    uint8_t pal[256][3];
    for (int a = 0; a < 255; ++a) {
        pal[a][0] = (uint8_t)round(127 + 127 * cos(2 * PI * a / 255.0));
        pal[a][1] = (uint8_t)round(127 + 127 * sin(2 * PI * a / 255.0));
        pal[a][2] = (uint8_t)round(127 + 127 * sin(2 * PI * a / 255.0));
    }
    pal[255][0] = 255; pal[255][1] = 255; pal[255][2] = 255;
    long double step = size_val / (horiz << 3);
    long double absc2 = absc - step * ((horiz << 3) - 1) / 2.0;
    long double ordi2 = ordi - step * ((vert << 3) - 1) / 2.0;
    vector<uint8_t> allData(h.sizeImage, 0);
    atomic<int> linesLeft{vert};
    cout << "Starting calculation on " << omp_get_max_threads() << " threads..." << endl;
    #pragma omp parallel for schedule(dynamic)
    for (int b = 0; b < vert; ++b) {
        int nn = b << 3;
        for (int a = 0; a < horiz; ++a) {
            int mm = a << 3;
            long z_sum[3] = {0, 0, 0};
            for (int j = 0; j < 8; ++j) {
                long double n_coord = ordi2 + (nn + j) * step;
                for (int i = 0; i < 8; ++i) {
                    long double m_coord = absc2 + (mm + i) * step;
                    long double c_re = m_coord, d_im = n_coord;
                    int t = 50000;
                    long double cc, dd;
                    do {
                        cc = c_re * c_re;
                        dd = d_im * d_im;
                        d_im = 2 * c_re * d_im + n_coord;
                        c_re = cc - dd + m_coord;
                        t--;
                    } while (t > 0 && (cc + dd <= 10000.0));
                    int colorIdx = (t == 0) ? 255 : (t % 255);
                    z_sum[0] += pal[colorIdx][0];
                    z_sum[1] += pal[colorIdx][1];
                    z_sum[2] += pal[colorIdx][2];
                }
            }
            int pixelPos = b * rowSize + a * 3;
            allData[pixelPos + 0] = (uint8_t)(z_sum[0] >> 6);
            allData[pixelPos + 1] = (uint8_t)(z_sum[1] >> 6);
            allData[pixelPos + 2] = (uint8_t)(z_sum[2] >> 6);
        }
        int current = --linesLeft;
        if (current % 10 == 0 || current < 10) {
            #pragma omp critical
            {
                cout << "Lines remaining: " << current << "    \r" << flush;
            }
        }
    }
    ofstream f("Mandelbrot.bmp", ios::binary);
    if (f.is_open()) {
        f.write(reinterpret_cast<char*>(&h), 54);
        f.write(reinterpret_cast<char*>(allData.data()), allData.size());
        f.close();
        cout << "\nFinished! Mandelbrot.bmp saved." << endl;
    }
    return 0;
}
