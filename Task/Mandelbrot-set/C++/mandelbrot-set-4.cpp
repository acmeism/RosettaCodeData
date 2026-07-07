/*
 * The freely distributable C++ compiler is called g++.
 * Original project:
 * https://github.com/Divetoxx/Mandelbrot
 */
#include <iostream>
#include <fstream>
#include <vector>
#include <cmath>
#include <cstdint>
#include <string>
#include <atomic>
#include <omp.h>
#include <cstdio>
#include <iomanip>
#include <gmp.h>
#include <mpfr.h>
using namespace std;
const double PI = 3.14159265358979323846;
const mpfr_prec_t MPFR_BITS = 5000;
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
struct ComplexDouble {
    double re;
    double im;
};
int main() {
    string absc_str, ordi_str, size_str;
    absc_str = "-1.7491311840575335110236048528001036247123430447933925298694915282522178938437759580179";
    ordi_str = "-0.0001996960702541036804654299663680287246637758588467627907752429037173153157138373325";
    size_str = "2.84e-82";
    const int targetW = 2160;
    const int targetH = 2160;
    const int scale = 8;
    const int rawW = targetW * scale;
    const int rawH = targetH * scale;
    const int frame = 140;
    cout << "Step 1: Calculating Reference Orbit using Perturbation..." << endl;
    mpfr_t rx, ry, zr, zi, zr2, zi2, tmp, sz, st;
    mpfr_inits2(MPFR_BITS, rx, ry, zr, zi, zr2, zi2, tmp, sz, st, NULL);
    mpfr_set_str(rx, absc_str.c_str(), 10, MPFR_RNDN);
    mpfr_set_str(ry, ordi_str.c_str(), 10, MPFR_RNDN);
    mpfr_set_str(sz, size_str.c_str(), 10, MPFR_RNDN);
    mpfr_div_ui(st, sz, rawW, MPFR_RNDN);
    double step_d = mpfr_get_d(st, MPFR_RNDN);
    vector<ComplexDouble> ref_orbit_double(50005);
    mpfr_set_ui(zr, 0, MPFR_RNDN);
    mpfr_set_ui(zi, 0, MPFR_RNDN);
    mpfr_set_ui(zr2, 0, MPFR_RNDN);
    mpfr_set_ui(zi2, 0, MPFR_RNDN);
    uint32_t ref_i = 0;
    bool escaped = false;
    while (ref_i < 50000) {
        ref_orbit_double[ref_i].re = mpfr_get_d(zr, MPFR_RNDN);
        ref_orbit_double[ref_i].im = mpfr_get_d(zi, MPFR_RNDN);
        mpfr_mul(tmp, zr, zi, MPFR_RNDN);
        mpfr_mul_ui(zi, tmp, 2, MPFR_RNDN);
        mpfr_add(zi, zi, ry, MPFR_RNDN);
        mpfr_sub(zr, zr2, zi2, MPFR_RNDN);
        mpfr_add(zr, zr, rx, MPFR_RNDN);
        mpfr_mul(zr2, zr, zr, MPFR_RNDN);
        mpfr_mul(zi2, zi, zi, MPFR_RNDN);
        if (escaped) {
            ref_i++;
            break;
        }
        mpfr_add(tmp, zr2, zi2, MPFR_RNDN);
        if (mpfr_cmp_d(tmp, 4.0) >= 0) {
            escaped = true;
        }
        ref_i++;
    }
    ref_orbit_double[ref_i].re = mpfr_get_d(zr, MPFR_RNDN);
    ref_orbit_double[ref_i].im = mpfr_get_d(zi, MPFR_RNDN);
    uint32_t max_valid_ref_iter = ref_i;
    mpfr_clears(rx, ry, zr, zi, zr2, zi2, tmp, sz, st, NULL);
    uint8_t pal[256][3];
    for (int a = 0; a < 255; ++a) {
        pal[a][0] = (uint8_t)round(127.0 + 127.0 * cos(2.0 * PI * a / 255.0)); // Blue
        pal[a][1] = (uint8_t)round(127.0 + 127.0 * sin(2.0 * PI * a / 255.0)); // Green
        pal[a][2] = (uint8_t)round(127.0 + 127.0 * sin(2.0 * PI * a / 255.0)); // Red
    }
    pal[255][0] = 255; pal[255][1] = 255; pal[255][2] = 255;
    cout << "Step 2: Stream rendering Mandelbrot140.bmp (" << targetW << "x" << targetH << ")..." << endl;
    int rowSize = (targetW * 3 + 3) & ~3;
    BMPHeader header;
    header.width = targetW;
    header.height = targetH;
    header.sizeImage = rowSize * targetH;
    header.size = header.sizeImage + 54;
    ofstream f("Mandelbrot140.bmp", ios::binary);
    f.write(reinterpret_cast<char*>(&header), 54);
    vector<uint8_t> rowBuffer(rowSize);
    for (int y = 0; y < targetH; ++y) {
        #pragma omp parallel for schedule(dynamic)
        for (int x = 0; x < targetW; ++x) {
            uint32_t rSum = 0, gSum = 0, bSum = 0;
            const ComplexDouble* ref_ptr = ref_orbit_double.data();
            for (int j = 0; j < scale; ++j) {
                size_t b = (size_t)y * scale + j;
                double delta_imc = (double)((long long)b - (rawH / 2)) * step_d;
                for (int i = 0; i < scale; ++i) {
                    size_t a = (size_t)x * scale + i;
                    double delta_rec = (double)((long long)a - (rawW / 2)) * step_d;
                    uint32_t index = 0;
                    double delta_re = 0.0;
                    double delta_im = 0.0;
                    double z_re = 0.0;
                    double z_im = 0.0;
                    uint32_t iter = 0;
                    while (iter < max_valid_ref_iter) {
                        if ((z_re * z_re + z_im * z_im) >= 40000.0) {
                            break;
                        }
                        if ((z_re * z_re + z_im * z_im) < (delta_re * delta_re + delta_im * delta_im)) {
                            index = 0;
                            delta_re = z_re;
                            delta_im = z_im;
                        }
                        for (int k = 0; k < 2; ++k) {
                            double Ur = ref_ptr[index].re;
                            double Ui = ref_ptr[index].im;
                            double next_delta_im = 2.0 * Ur * delta_im + 2.0 * Ui * delta_re + 2.0 * delta_re * delta_im + delta_imc;
                            delta_re = 2.0 * Ur * delta_re - 2.0 * Ui * delta_im + delta_re * delta_re - delta_im * delta_im + delta_rec;
                            delta_im = next_delta_im;
                            index++;
                        }
                        z_re = ref_ptr[index].re + delta_re;
                        z_im = ref_ptr[index].im + delta_im;
                        iter += 2;
                    }
                    int final_t = 50000 - iter;
                    uint8_t t = (final_t == 0) ? 255 : (uint8_t)(final_t % 254);
                    int colorIdx = (t == 255) ? 255 : (t - frame + 255) % 255;
                    bSum += pal[colorIdx][0];
                    gSum += pal[colorIdx][1];
                    rSum += pal[colorIdx][2];
                }
            }
            int outIdx = x * 3;
            rowBuffer[outIdx + 0] = (uint8_t)(bSum >> 6);
            rowBuffer[outIdx + 1] = (uint8_t)(gSum >> 6);
            rowBuffer[outIdx + 2] = (uint8_t)(rSum >> 6);
        }
        f.write(reinterpret_cast<const char*>(rowBuffer.data()), rowSize);
        if ((y + 1) % 10 == 0 || y == targetH - 1) {
            cout << "Progress: " << (y + 1) << "/" << targetH << "\r" << flush;
        }
    }
    f.close();
    cout << "\nDone! Mandelbrot140.bmp successfully saved." << endl;
    return 0;
}
