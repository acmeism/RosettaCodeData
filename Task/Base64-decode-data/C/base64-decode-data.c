#include <stdio.h>
#include <stdlib.h>

typedef unsigned char ubyte;
const ubyte BASE64[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

int findIndex(const ubyte val) {
    if ('A' <= val && val <= 'Z') {
        return val - 'A';
    }
    if ('a' <= val && val <= 'z') {
        return val - 'a' + 26;
    }
    if ('0' <= val && val <= '9') {
        return val - '0' + 52;
    }
    if (val == '+') {
        return 62;
    }
    if (val == '/') {
        return 63;
    }
    return -1;
}

int decode(const ubyte source[], ubyte sink[]) {
    const size_t length = strlen(source);
    const ubyte *it = source;
    const ubyte *end = source + length;
    int acc;

    if (length % 4 != 0) {
        return 1;
    }

    while (it != end) {
        const ubyte b1 = *it++;
        const ubyte b2 = *it++;
        const ubyte b3 = *it++;         // might be the first padding byte
        const ubyte b4 = *it++;         // might be the first or second padding byte

        const int i1 = findIndex(b1);
        const int i2 = findIndex(b2);

        acc = i1 << 2;                  // six bits came from the first byte
        acc |= i2 >> 4;                 // two bits came from the first byte
        *sink++ = acc;                  // output the first byte

        if (b3 != '=') {
            const int i3 = findIndex(b3);

            acc = (i2 & 0xF) << 4;      // four bits came from the second byte
            acc += i3 >> 2;             // four bits came from the second byte
            *sink++ = acc;              // output the second byte

            if (b4 != '=') {
                const int i4 = findIndex(b4);

                acc = (i3 & 0x3) << 6;  // two bits came from the third byte
                acc |= i4;              // six bits came from the third byte
                *sink++ = acc;          // output the third byte
            }
        }
    }

    *sink = '\0';   // add the sigil for end of string
    return 0;
}

int main() {
    ubyte data[] = "VG8gZXJyIGlzIGh1bWFuLCBidXQgdG8gcmVhbGx5IGZvdWwgdGhpbmdzIHVwIHlvdSBuZWVkIGEgY29tcHV0ZXIuCiAgICAtLVBhdWwgUi5FaHJsaWNo";
    ubyte decoded[1024];

    printf("%s\n\n", data);
    decode(data, decoded);
    printf("%s\n\n", decoded);

    return 0;
}
