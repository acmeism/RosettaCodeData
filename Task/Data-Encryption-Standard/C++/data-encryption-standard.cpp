#include <algorithm>
#include <array>
#include <bitset>
#include <iomanip>
#include <iostream>
#include <ostream>
#include <vector>

template <size_t N>
std::ostream& operator<<(std::ostream& out, std::bitset<N>& bs) {
    // debug
    for (int i = 0; i < N; i += 8) {
        out << bs.test(i + 0) << bs.test(i + 1) << bs.test(i + 2) << bs.test(i + 3) << '_';
        if (i + 7 < N) {
            out << bs.test(i + 4) << bs.test(i + 5) << bs.test(i + 6) << bs.test(i + 7) << ' ';
        } else {
            out << "0000 ";
        }
    }
    return out;
}

namespace DES {
    typedef unsigned char ubyte;
    typedef std::array<ubyte, 8> key_t;

    namespace impl {
        const int PC1[] = {
            57, 49, 41, 33, 25, 17,  9,
             1, 58, 50, 42, 34, 26, 18,
            10,  2, 59, 51, 43, 35, 27,
            19, 11,  3, 60, 52, 44, 36,
            63, 55, 47, 39, 31, 23, 15,
             7, 62, 54, 46, 38, 30, 22,
            14,  6, 61, 53, 45, 37, 29,
            21, 13,  5, 28, 20, 12,  4
        };

        const int PC2[] = {
            14, 17, 11, 24,  1,  5,
             3, 28, 15,  6, 21, 10,
            23, 19, 12,  4, 26,  8,
            16,  7, 27, 20, 13,  2,
            41, 52, 31, 37, 47, 55,
            30, 40, 51, 45, 33, 48,
            44, 49, 39, 56, 34, 53,
            46, 42, 50, 36, 29, 32
        };

        const int IP[] = {
            58, 50, 42, 34, 26, 18, 10,  2,
            60, 52, 44, 36, 28, 20, 12,  4,
            62, 54, 46, 38, 30, 22, 14,  6,
            64, 56, 48, 40, 32, 24, 16,  8,
            57, 49, 41, 33, 25, 17,  9,  1,
            59, 51, 43, 35, 27, 19, 11,  3,
            61, 53, 45, 37, 29, 21, 13,  5,
            63, 55, 47, 39, 31, 23, 15,  7
        };

        const int E[] = {
            32,  1,  2,  3,  4,  5,
             4,  5,  6,  7,  8,  9,
             8,  9, 10, 11, 12, 13,
            12, 13, 14, 15, 16, 17,
            16, 17, 18, 19, 20, 21,
            20, 21, 22, 23, 24, 25,
            24, 25, 26, 27, 28, 29,
            28, 29, 30, 31, 32,  1
        };

        const int S[][64] = {
            {
                14,  4, 13,  1,  2, 15, 11,  8,  3, 10,  6, 12,  5,  9,  0,  7,
                 0, 15,  7,  4, 14,  2, 13,  1, 10,  6, 12, 11,  9,  5,  3,  8,
                 4,  1, 14,  8, 13,  6,  2, 11, 15, 12,  9,  7,  3, 10,  5,  0,
                15, 12,  8,  2,  4,  9,  1,  7,  5, 11,  3, 14, 10,  0,  6, 13
            },
            {
                15,  1,  8, 14,  6, 11,  3,  4,  9,  7,  2, 13, 12,  0,  5, 10,
                 3, 13,  4,  7, 15,  2,  8, 14, 12,  0,  1, 10,  6,  9, 11,  5,
                 0, 14,  7, 11, 10,  4, 13,  1,  5,  8, 12,  6,  9,  3,  2, 15,
                13,  8, 10,  1,  3, 15,  4,  2, 11,  6,  7, 12,  0,  5, 14,  9
            },
            {
                10,  0,  9, 14,  6,  3, 15,  5,  1, 13, 12,  7, 11,  4,  2,  8,
                13,  7,  0,  9,  3,  4,  6, 10,  2,  8,  5, 14, 12, 11, 15,  1,
                13,  6,  4,  9,  8, 15,  3,  0, 11,  1,  2, 12,  5, 10, 14,  7,
                 1, 10, 13,  0,  6,  9,  8,  7,  4, 15, 14,  3, 11,  5,  2, 12
            },
            {
                 7, 13, 14,  3,  0,  6,  9, 10,  1,  2,  8,  5, 11, 12,  4, 15,
                13,  8, 11,  5,  6, 15,  0,  3,  4,  7,  2, 12,  1, 10, 14,  9,
                10,  6,  9,  0, 12, 11,  7, 13, 15,  1,  3, 14,  5,  2,  8,  4,
                 3, 15,  0,  6, 10,  1, 13,  8,  9,  4,  5, 11, 12,  7,  2, 14
            },
            {
                 2, 12,  4,  1,  7, 10, 11,  6,  8,  5,  3, 15, 13,  0, 14,  9,
                14, 11,  2, 12,  4,  7, 13,  1,  5,  0, 15, 10,  3,  9,  8,  6,
                 4,  2,  1, 11, 10, 13,  7,  8, 15,  9, 12,  5,  6,  3,  0, 14,
                11,  8, 12,  7,  1, 14,  2, 13,  6, 15,  0,  9, 10,  4,  5,  3
            },
            {
                12,  1, 10, 15,  9,  2,  6,  8,  0, 13,  3,  4, 14,  7,  5, 11,
                10, 15,  4,  2,  7, 12,  9,  5,  6,  1, 13, 14,  0, 11,  3,  8,
                 9, 14, 15,  5,  2,  8, 12,  3,  7,  0,  4, 10,  1, 13, 11,  6,
                 4,  3,  2, 12,  9,  5, 15, 10, 11, 14,  1,  7,  6,  0,  8, 13
            },
            {
                 4, 11,  2, 14, 15,  0,  8, 13,  3, 12,  9,  7,  5, 10,  6,  1,
                13,  0, 11,  7,  4,  9,  1, 10, 14,  3,  5, 12,  2, 15,  8,  6,
                 1,  4, 11, 13, 12,  3,  7, 14, 10, 15,  6,  8,  0,  5,  9,  2,
                 6, 11, 13,  8,  1,  4, 10,  7,  9,  5,  0, 15, 14,  2,  3, 12
            },
            {
                13,  2,  8,  4,  6, 15, 11,  1, 10,  9,  3, 14,  5,  0, 12,  7,
                 1, 15, 13,  8, 10,  3,  7,  4, 12,  5,  6, 11,  0, 14,  9,  2,
                 7, 11,  4,  1,  9, 12, 14,  2,  0,  6, 10, 13, 15,  3,  5,  8,
                 2,  1, 14,  7,  4, 10,  8, 13, 15, 12,  9,  0,  3,  5,  6, 11
            }
        };

        const int P[] = {
            16,  7, 20, 21,
            29, 12, 28, 17,
             1, 15, 23, 26,
             5, 18, 31, 10,
             2,  8, 24, 14,
            32, 27,  3,  9,
            19, 13, 30,  6,
            22, 11,  4, 25
        };

        const int IP2[] = {
            40,  8, 48, 16, 56, 24, 64, 32,
            39,  7, 47, 15, 55, 23, 63, 31,
            38,  6, 46, 14, 54, 22, 62, 30,
            37,  5, 45, 13, 53, 21, 61, 29,
            36,  4, 44, 12, 52, 20, 60, 28,
            35,  3, 43, 11, 51, 19, 59, 27,
            34,  2, 42, 10, 50, 18, 58, 26,
            33,  1, 41,  9, 49, 17, 57, 25
        };

        const int SHIFTS[] = { 1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1 };

        std::bitset<64> toBitSet(const key_t& key) {
            std::bitset<64> bs;
            for (int i = 0; i < 8; ++i) {
                bs.set(8 * i + 0, key[i] & 0x80);
                bs.set(8 * i + 1, key[i] & 0x40);
                bs.set(8 * i + 2, key[i] & 0x20);
                bs.set(8 * i + 3, key[i] & 0x10);

                bs.set(8 * i + 4, key[i] & 0x08);
                bs.set(8 * i + 5, key[i] & 0x04);
                bs.set(8 * i + 6, key[i] & 0x02);
                bs.set(8 * i + 7, key[i] & 0x01);
            }
            return bs;
        }

        template <size_t N>
        std::bitset<N * 8> toBitSet(const std::array<ubyte, N>& src) {
            std::bitset<N * 8> bs;
            for (int i = 0; i < N; ++i) {
                bs.set(8 * i + 0, src[i] & 0x80);
                bs.set(8 * i + 1, src[i] & 0x40);
                bs.set(8 * i + 2, src[i] & 0x20);
                bs.set(8 * i + 3, src[i] & 0x10);

                bs.set(8 * i + 4, src[i] & 0x08);
                bs.set(8 * i + 5, src[i] & 0x04);
                bs.set(8 * i + 6, src[i] & 0x02);
                bs.set(8 * i + 7, src[i] & 0x01);
            }
            return bs;
        }

        template <size_t N>
        std::array<ubyte, N / 8> toArray(const std::bitset<N>& bs) {
            std::array<ubyte, N / 8> arr;
            std::fill_n(arr.begin(), N / 8, 0);
            for (int i = 0; i < N / 8; ++i) {
                arr[i] |= (bs[8 * i + 0] << 7);
                arr[i] |= (bs[8 * i + 1] << 6);
                arr[i] |= (bs[8 * i + 2] << 5);
                arr[i] |= (bs[8 * i + 3] << 4);

                arr[i] |= (bs[8 * i + 4] << 3);
                arr[i] |= (bs[8 * i + 5] << 2);
                arr[i] |= (bs[8 * i + 6] << 1);
                arr[i] |= (bs[8 * i + 7] << 0);
            }
            return arr;
        }

        template <size_t N>
        std::bitset<N> shiftLeft(const std::bitset<N>& bs, int len, int times) {
            std::bitset<N> output;
            for (int i = 0; i < len; ++i) {
                output[i] = bs[i];
            }
            for (int t = 0; t < times; ++t) {
                int temp = output[0];
                for (int i = 1; i < len; ++i) {
                    output[i - 1] = output[i];
                }
                output[len - 1] = temp;
            }
            return output;
        }

        std::array<std::bitset<48>, 17> getSubKeys(const key_t& key) {
            std::array<std::bitset<56>, 17> c;
            std::array<std::bitset<28>, 17> d;
            std::bitset<56> kp;

            auto k = toBitSet(key);

            /* permute 'key' using table PC1 */
            for (int i = 0; i < 56; ++i) {
                kp[i] = k[PC1[i] - 1];
            }

            /* split 'kp' in half and process the resulting series of 'c' and 'd' */
            for (int i = 0; i < 28; ++i) {
                c[0][i] = kp[i];
                d[0][i] = kp[i + 28];
            }

            /* shift the components of c and d */
            for (int i = 1; i < 17; ++i) {
                c[i] = shiftLeft(c[i - 1], 28, SHIFTS[i - 1]);
                d[i] = shiftLeft(d[i - 1], 28, SHIFTS[i - 1]);
            }

            /* merge 'd' into 'c' */
            for (int i = 1; i < 17; ++i) {
                for (int j = 28; j < 56; ++j) {
                    c[i][j] = d[i][j - 28];
                }
            }

            /* form the sub-keys and store them in 'ks'
             * permute 'c' using table PC2 */
            std::array<std::bitset<48>, 17> ks;
            for (int i = 1; i < 17; ++i) {
                for (int j = 0; j < 48; ++j) {
                    ks[i][j] = c[i][PC2[j] - 1];
                }
            }

            return ks;
        }

        std::bitset<32> f(const std::bitset<48>& ks, std::bitset<32>& r) {
            // permute 'r' using table E
            std::bitset<48> er;
            for (int i = 0; i < 48; ++i) {
                er[i] = r[E[i] - 1];
            }

            // xor 'er' with 'ks' and store back into 'er'
            er ^= ks;

            // process 'er' six bits at a time and store resulting four bits in 'sr'
            std::bitset<32> sr;
            for (int i = 0; i < 8; ++i) {
                int j = 6 * i;
                std::bitset<6> b;
                for (int k = 0; k < 6; ++k) {
                    b[k] = er[j + k] != 0;
                }
                int row = 2 * b[0] + b[5];
                int col = 8 * b[1] + 4 * b[2] + 2 * b[3] + b[4];
                int m = S[i][row * 16 + col];   // apply table s
                int n = 1;
                while (m > 0) {
                    int p = m % 2;
                    sr[(i + 1) * 4 - n] = (p == 1);
                    m /= 2;
                    n++;
                }
            }

            // permute sr using table P
            std::bitset<32> sp;
            for (int i = 0; i < 32; ++i) {
                sp[i] = sr[P[i] - 1];
            }
            return sp;
        }

        std::array<ubyte, 8> processMessage(const std::array<std::bitset<48>, 17>& ks, const std::array<ubyte, 8>& message) {
            auto m = toBitSet(message);

            // permute 'message' using table IP
            std::bitset<64> mp;
            for (int i = 0; i < 64; ++i) {
                mp[i] = m[IP[i] - 1];
            }

            // split 'mp' in half and process the resulting series of 'l' and 'r
            std::array<std::bitset<32>, 17> left;
            std::array<std::bitset<32>, 17> right;
            for (int i = 0; i < 32; ++i) {
                left[0][i] = mp[i];
                right[0][i] = mp[i + 32];
            }
            for (int i = 1; i < 17; ++i) {
                left[i] = right[i - 1];
                auto fs = f(ks[i], right[i - 1]);
                left[i - 1] ^= fs;
                right[i] = left[i - 1];
            }

            // amalgamate r[16] and l[16] (in that order) into 'e'
            std::bitset<64> e;
            for (int i = 0; i < 32; ++i) {
                e[i] = right[16][i];
            }
            for (int i = 32; i < 64; ++i) {
                e[i] = left[16][i - 32];
            }

            // permute 'e' using table IP2 ad return result as a hex string
            std::bitset<64> ep;
            for (int i = 0; i < 64; ++i) {
                ep[i] = e[IP2[i] - 1];
            }
            return toArray(ep);
        }
    }

    std::vector<ubyte> encrypt(const key_t& key, const std::vector<ubyte>& message) {
        auto ks = impl::getSubKeys(key);
        std::vector<ubyte> m(message);

        // pad the message so there are 8 byte groups
        ubyte padByte = 8 - m.size() % 8;
        for (int i = 0; i < padByte; ++i) {
            m.push_back(padByte);
        }

        std::vector<ubyte> sb;
        for (size_t i = 0; i < m.size(); i += 8) {
            std::array<ubyte, 8> part;
            std::copy_n(m.begin() + i, 8, part.begin());
            part = impl::processMessage(ks, part);
            std::copy(part.begin(), part.end(), std::back_inserter(sb));
        }

        return sb;
    }

    std::vector<ubyte> decrypt(const key_t& key, const std::vector<ubyte>& encoded) {
        auto ks = impl::getSubKeys(key);
        // reverse the subkeys
        std::reverse(ks.begin() + 1, ks.end());

        std::vector<ubyte> decoded;
        for (int i = 0; i < encoded.size(); i += 8) {
            std::array<ubyte, 8> part;
            std::copy_n(encoded.begin() + i, 8, part.begin());
            part = impl::processMessage(ks, part);
            std::copy(part.begin(), part.end(), std::back_inserter(decoded));
        }

        // remove the padding bytes from the decoded message
        auto padByte = decoded.back();
        decoded.resize(decoded.size() - padByte);
        return decoded;
    }

    std::ostream& operator<<(std::ostream& os, const key_t& key) {
        os << std::setfill('0') << std::uppercase << std::hex;
        for (int i = 0; i < 8; ++i) {
            os << std::setw(2) << (int)key[i];
        }
        return os;
    }

    std::ostream& operator<<(std::ostream& os, const std::vector<ubyte>& msg) {
        os << std::setfill('0') << std::uppercase << std::hex;
        for (auto b : msg) {
            os << std::setw(2) << (int)b;
        }
        return os;
    }
}

int main() {
    using namespace std;
    using namespace DES;

    key_t keys[] = {
        {0x13, 0x34, 0x57, 0x79, 0x9B, 0xBC, 0xDF, 0xF1},
        {0x0E, 0x32, 0x92, 0x32, 0xEA, 0x6D, 0x0D, 0x73},
        {0x0E, 0x32, 0x92, 0x32, 0xEA, 0x6D, 0x0D, 0x73}
    };
    vector<vector<ubyte>> messages = {
        {0x01, 0x23, 0x45, 0x67, 0x89, 0xAB, 0xCD, 0xEF},
        {0x87, 0x87, 0x87, 0x87, 0x87, 0x87, 0x87, 0x87},
        {0x59, 0x6F, 0x75, 0x72, 0x20, 0x6C, 0x69, 0x70, 0x73, 0x20, 0x61, 0x72, 0x65, 0x20, 0x73, 0x6D, 0x6F, 0x6F, 0x74, 0x68, 0x65, 0x72, 0x20, 0x74, 0x68, 0x61, 0x6E, 0x20, 0x76, 0x61, 0x73, 0x65, 0x6C, 0x69, 0x6E, 0x65, 0x0D, 0x0A}
    };

    for (int i = 0; i < 3; ++i) {
        cout << "Key     : " << keys[i] << '\n';
        cout << "Message : " << messages[i] << '\n';

        auto encoded = encrypt(keys[i], messages[i]);
        cout << "Encoded : " << encoded << endl;

        auto decoded = decrypt(keys[i], encoded);
        cout << "Decoded : " << decoded << endl;

        cout << '\n';
    }

    return 0;
}
