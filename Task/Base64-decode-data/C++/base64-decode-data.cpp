#include <algorithm>
#include <iostream>
#include <string>
#include <vector>

typedef unsigned char ubyte;
const auto BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

std::vector<ubyte> encode(const std::vector<ubyte>& source) {
    auto it = source.cbegin();
    auto end = source.cend();

    std::vector<ubyte> sink;
    while (it != end) {
        auto b1 = *it++;
        int acc;

        sink.push_back(BASE64[b1 >> 2]);            // first output (first six bits from b1)

        acc = (b1 & 0x3) << 4;                      // last two bits from b1
        if (it != end) {
            auto b2 = *it++;
            acc |= (b2 >> 4);                       // first four bits from b2

            sink.push_back(BASE64[acc]);            // second output

            acc = (b2 & 0xF) << 2;                  // last four bits from b2
            if (it != end) {
                auto b3 = *it++;
                acc |= (b3 >> 6);                   // first two bits from b3

                sink.push_back(BASE64[acc]);        // third output
                sink.push_back(BASE64[b3 & 0x3F]);  // fouth output (final six bits from b3)
            } else {
                sink.push_back(BASE64[acc]);        // third output
                sink.push_back('=');                // fourth output (1 byte padding)
            }
        } else {
            sink.push_back(BASE64[acc]);            // second output
            sink.push_back('=');                    // third output (first padding byte)
            sink.push_back('=');                    // fourth output (second padding byte)
        }
    }
    return sink;
}

int findIndex(ubyte val) {
    if ('A' <= val && val <= 'Z') {
        return val - 'A';
    }
    if ('a' <= val && val <= 'z') {
        return val - 'a' + 26;
    }
    if ('0' <= val && val <= '9') {
        return val - '0' + 52;
    }
    if ('+' == val) {
        return 62;
    }
    if ('/' == val) {
        return 63;
    }
    return -1;
}

std::vector<ubyte> decode(const std::vector<ubyte>& source) {
    if (source.size() % 4 != 0) {
        throw new std::runtime_error("Error in size to the decode method");
    }

    auto it = source.cbegin();
    auto end = source.cend();

    std::vector<ubyte> sink;
    while (it != end) {
        auto b1 = *it++;
        auto b2 = *it++;
        auto b3 = *it++; // might be first padding byte
        auto b4 = *it++; // might be first or second padding byte

        auto i1 = findIndex(b1);
        auto i2 = findIndex(b2);
        auto acc = i1 << 2;     // six bits came from the first byte
        acc |= i2 >> 4;         // two bits came from the first byte

        sink.push_back(acc);    // output the first byte

        if (b3 != '=') {
            auto i3 = findIndex(b3);

            acc = (i2 & 0xF) << 4;  // four bits came from the second byte
            acc |= i3 >> 2;         // four bits came from the second byte

            sink.push_back(acc);    // output the second byte

            if (b4 != '=') {
                auto i4 = findIndex(b4);

                acc = (i3 & 0x3) << 6;  // two bits came from the third byte
                acc |= i4;              // six bits came from the third byte

                sink.push_back(acc);    // output the third byte
            }
        }
    }
    return sink;
}

int main() {
    using namespace std;

    string data = "VG8gZXJyIGlzIGh1bWFuLCBidXQgdG8gcmVhbGx5IGZvdWwgdGhpbmdzIHVwIHlvdSBuZWVkIGEgY29tcHV0ZXIuCiAgICAtLVBhdWwgUi5FaHJsaWNo";
    vector<ubyte> datav{ begin(data), end(data) };
    cout << data << "\n\n" << decode(datav).data() << endl;

    return 0;
}
