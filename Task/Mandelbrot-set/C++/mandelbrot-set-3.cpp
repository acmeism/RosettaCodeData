/*
 * The freely distributable C++ compiler is called g++.
 */
#include <iostream>
#include <fstream>
#include <vector>
#include <cmath>
#include <cstdint>
#include <string>
#include <cstdio>
#include <iomanip>
using namespace std;
const long double PI = 3.14159265358979323846264338327950288L;
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
    long double rx = stold("-1.758008286774384722");
    long double ry = stold("-0.012039512139649579");
    long double sz = stold("0.0000000000000073");
    const int targetW = 2160;
    const int targetH = 2160;
    const int scale = 8;
    const int rawW = targetW * scale;
    const int rawH = targetH * scale;
    const int frame = 100;
    const int max_iter = 50000;
    long double step_d = sz / (long double)rawW;
    uint8_t pal[256][3];
    for (int a = 0; a < 255; ++a) {
        pal[a][0] = (uint8_t)round(127.0 + 127.0 * cos(2.0 * PI * a / 255.0)); // Blue
        pal[a][1] = (uint8_t)round(127.0 + 127.0 * sin(2.0 * PI * a / 255.0)); // Green
        pal[a][2] = (uint8_t)round(127.0 + 127.0 * sin(2.0 * PI * a / 255.0)); // Red
    }
    pal[255][0] = 255; pal[255][1] = 255; pal[255][2] = 255;
    cout << "Step 1: Rendering Mandelbrot using 80-bit long double (" << targetW << "x" << targetH << ")..." << endl;
    int rowSize = (targetW * 3 + 3) & ~3;
    BMPHeader header;
    header.width = targetW;
    header.height = targetH;
    header.sizeImage = rowSize * targetH;
    header.size = header.sizeImage + 54;
    ofstream f("Mandelbrot Set Image 105.bmp", ios::binary);
    f.write(reinterpret_cast<char*>(&header), 54);
    #pragma omp parallel for schedule(dynamic)
    for (int y = 0; y < targetH; ++y) {
        vector<uint8_t> threadRowBuffer(rowSize, 0);
        for (int x = 0; x < targetW; ++x) {
            uint32_t rSum = 0, gSum = 0, bSum = 0;
            for (int j = 0; j < scale; ++j) {
                size_t b = (size_t)y * scale + j;
                long double c_im = ry + (long double)((long long)b - (rawH / 2)) * step_d;
                for (int i = 0; i < scale; ++i) {
                    size_t a = (size_t)x * scale + i;
                    long double c_re = rx + (long double)((long long)a - (rawW / 2)) * step_d;
                    long double z_re = 0.0L;
                    long double z_im = 0.0L;
                    int iter = 0;
                    while (iter < max_iter) {
                        long double z_re2 = z_re * z_re;
                        long double z_im2 = z_im * z_im;
                        if ((z_re2 + z_im2) >= 40000.0L) {
                            break;
                        }
                        z_im = 2.0L * z_re * z_im + c_im;
                        z_re = z_re2 - z_im2 + c_re;
                        iter++;
                    }
                    int final_t = max_iter - iter;
                    uint8_t t = (final_t == 0) ? 255 : (uint8_t)(final_t % 254);
                    int colorIdx = (t == 255) ? 255 : (t - frame + 255) % 255;
                    bSum += pal[colorIdx][0];
                    gSum += pal[colorIdx][1];
                    rSum += pal[colorIdx][2];
                }
            }
            int outIdx = x * 3;
            threadRowBuffer[outIdx + 0] = (uint8_t)(bSum >> 6);
            threadRowBuffer[outIdx + 1] = (uint8_t)(gSum >> 6);
            threadRowBuffer[outIdx + 2] = (uint8_t)(rSum >> 6);
        }
        #pragma omp critical
        {
            f.seekp(54 + (streamoff)y * rowSize);
            f.write(reinterpret_cast<const char*>(threadRowBuffer.data()), rowSize);
        }
        if ((y + 1) % 10 == 0 || y == targetH - 1) {
            #pragma omp critical
            {
                cout << "Progress: " << (y + 1) << "/" << targetH << "\r" << flush;
            }
        }
    }
    f.close();
    cout << "\nDone! Mandelbrot Set Image 105.bmp successfully saved." << endl;
    return 0;
}

