import std.stdio, std.array, std.bitmanip;

immutable PC1 = [
    57, 49, 41, 33, 25, 17,  9,
     1, 58, 50, 42, 34, 26, 18,
    10,  2, 59, 51, 43, 35, 27,
    19, 11,  3, 60, 52, 44, 36,
    63, 55, 47, 39, 31, 23, 15,
     7, 62, 54, 46, 38, 30, 22,
    14,  6, 61, 53, 45, 37, 29,
    21, 13,  5, 28, 20, 12,  4
];

immutable PC2 = [
    14, 17, 11, 24,  1,  5,
     3, 28, 15,  6, 21, 10,
    23, 19, 12,  4, 26,  8,
    16,  7, 27, 20, 13,  2,
    41, 52, 31, 37, 47, 55,
    30, 40, 51, 45, 33, 48,
    44, 49, 39, 56, 34, 53,
    46, 42, 50, 36, 29, 32
];

immutable IP = [
    58, 50, 42, 34, 26, 18, 10,  2,
    60, 52, 44, 36, 28, 20, 12,  4,
    62, 54, 46, 38, 30, 22, 14,  6,
    64, 56, 48, 40, 32, 24, 16,  8,
    57, 49, 41, 33, 25, 17,  9,  1,
    59, 51, 43, 35, 27, 19, 11,  3,
    61, 53, 45, 37, 29, 21, 13,  5,
    63, 55, 47, 39, 31, 23, 15,  7
];

immutable E = [
    32,  1,  2,  3,  4,  5,
     4,  5,  6,  7,  8,  9,
     8,  9, 10, 11, 12, 13,
    12, 13, 14, 15, 16, 17,
    16, 17, 18, 19, 20, 21,
    20, 21, 22, 23, 24, 25,
    24, 25, 26, 27, 28, 29,
    28, 29, 30, 31, 32,  1
];

immutable S = [
    [
        14,  4, 13,  1,  2, 15, 11,  8,  3, 10,  6, 12,  5,  9,  0,  7,
         0, 15,  7,  4, 14,  2, 13,  1, 10,  6, 12, 11,  9,  5,  3,  8,
         4,  1, 14,  8, 13,  6,  2, 11, 15, 12,  9,  7,  3, 10,  5,  0,
        15, 12,  8,  2,  4,  9,  1,  7,  5, 11,  3, 14, 10,  0,  6, 13
    ],
    [
        15,  1,  8, 14,  6, 11,  3,  4,  9,  7,  2, 13, 12,  0,  5, 10,
         3, 13,  4,  7, 15,  2,  8, 14, 12,  0,  1, 10,  6,  9, 11,  5,
         0, 14,  7, 11, 10,  4, 13,  1,  5,  8, 12,  6,  9,  3,  2, 15,
        13,  8, 10,  1,  3, 15,  4,  2, 11,  6,  7, 12,  0,  5, 14,  9
    ],
    [
        10,  0,  9, 14,  6,  3, 15,  5,  1, 13, 12,  7, 11,  4,  2,  8,
        13,  7,  0,  9,  3,  4,  6, 10,  2,  8,  5, 14, 12, 11, 15,  1,
        13,  6,  4,  9,  8, 15,  3,  0, 11,  1,  2, 12,  5, 10, 14,  7,
         1, 10, 13,  0,  6,  9,  8,  7,  4, 15, 14,  3, 11,  5,  2, 12
    ],
    [
         7, 13, 14,  3,  0,  6,  9, 10,  1,  2,  8,  5, 11, 12,  4, 15,
        13,  8, 11,  5,  6, 15,  0,  3,  4,  7,  2, 12,  1, 10, 14,  9,
        10,  6,  9,  0, 12, 11,  7, 13, 15,  1,  3, 14,  5,  2,  8,  4,
         3, 15,  0,  6, 10,  1, 13,  8,  9,  4,  5, 11, 12,  7,  2, 14
    ],
    [
         2, 12,  4,  1,  7, 10, 11,  6,  8,  5,  3, 15, 13,  0, 14,  9,
        14, 11,  2, 12,  4,  7, 13,  1,  5,  0, 15, 10,  3,  9,  8,  6,
         4,  2,  1, 11, 10, 13,  7,  8, 15,  9, 12,  5,  6,  3,  0, 14,
        11,  8, 12,  7,  1, 14,  2, 13,  6, 15,  0,  9, 10,  4,  5,  3
    ],
    [
        12,  1, 10, 15,  9,  2,  6,  8,  0, 13,  3,  4, 14,  7,  5, 11,
        10, 15,  4,  2,  7, 12,  9,  5,  6,  1, 13, 14,  0, 11,  3,  8,
         9, 14, 15,  5,  2,  8, 12,  3,  7,  0,  4, 10,  1, 13, 11,  6,
         4,  3,  2, 12,  9,  5, 15, 10, 11, 14,  1,  7,  6,  0,  8, 13
    ],
    [
         4, 11,  2, 14, 15,  0,  8, 13,  3, 12,  9,  7,  5, 10,  6,  1,
        13,  0, 11,  7,  4,  9,  1, 10, 14,  3,  5, 12,  2, 15,  8,  6,
         1,  4, 11, 13, 12,  3,  7, 14, 10, 15,  6,  8,  0,  5,  9,  2,
         6, 11, 13,  8,  1,  4, 10,  7,  9,  5,  0, 15, 14,  2,  3, 12
    ],
    [
        13,  2,  8,  4,  6, 15, 11,  1, 10,  9,  3, 14,  5,  0, 12,  7,
         1, 15, 13,  8, 10,  3,  7,  4, 12,  5,  6, 11,  0, 14,  9,  2,
         7, 11,  4,  1,  9, 12, 14,  2,  0,  6, 10, 13, 15,  3,  5,  8,
         2,  1, 14,  7,  4, 10,  8, 13, 15, 12,  9,  0,  3,  5,  6, 11
    ]
];

immutable P = [
    16,  7, 20, 21,
    29, 12, 28, 17,
     1, 15, 23, 26,
     5, 18, 31, 10,
     2,  8, 24, 14,
    32, 27,  3,  9,
    19, 13, 30,  6,
    22, 11,  4, 25
];

immutable IP2 = [
    40,  8, 48, 16, 56, 24, 64, 32,
    39,  7, 47, 15, 55, 23, 63, 31,
    38,  6, 46, 14, 54, 22, 62, 30,
    37,  5, 45, 13, 53, 21, 61, 29,
    36,  4, 44, 12, 52, 20, 60, 28,
    35,  3, 43, 11, 51, 19, 59, 27,
    34,  2, 42, 10, 50, 18, 58, 26,
    33,  1, 41,  9, 49, 17, 57, 25
];

immutable SHIFTS = [1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1];

BitArray bitArrayOfSize(ulong count) {
    bool[] buffer = new bool[count];
    return BitArray(buffer);
}

ubyte[] encrypt(const ubyte[] key, const ubyte[] message) in {
    assert(key.length == 8, "Incorrect key size");
} do {
    BitArray[] ks = getSubKeys(key);
    ubyte[] m = message.dup;

    // pad the message so there are 8 byte groups
    ubyte padByte = 8 - m.length % 8;
    foreach (_; 0..padByte) {
        m ~= padByte;
    }
    assert(m.length % 8 == 0);

    ubyte[] sb;
    foreach (i; 0..m.length / 8) {
        auto j = i * 8;
        auto enc = processMessage(m[j..j+8], ks);
        sb ~= enc;
    }

    return sb;
}

ubyte[] decrypt(const ubyte[] key, const ubyte[] encoded) in {
    assert(key.length == 8, "Incorrect key size");
} do {
    BitArray[] ks = getSubKeys(key);
    // reverse the subkeys
    foreach (i; 1..9) {
        auto temp = ks[i];
        ks[i] = ks[17 - i];
        ks[17 - i] = temp;
    }

    ubyte[] decoded;
    foreach (i; 0..encoded.length / 8) {
        auto j = i * 8;
        auto dec = processMessage(encoded[j..j+8], ks);
        decoded ~= dec;
    }

    // remove the padding bytes from the decoded message
    ubyte padByte = decoded[$ - 1];
    decoded.length -= padByte;

    return decoded;
}

private BitArray[] getSubKeys(const ubyte[] key) in {
    assert(key.length == 8);
} do {
    auto k = key.toBitArray();

    // permute 'key' using table PC1
    auto kp = bitArrayOfSize(56);
    foreach (i; 0..56) {
        kp[i] = k[PC1[i] - 1];
    }

    // split 'kp' in half and process the resulting series of 'c' and 'd'
    BitArray[] c;
    BitArray[] d;
    foreach (_; 0..18) {
        c ~= bitArrayOfSize(56);
        d ~= bitArrayOfSize(28);
    }
    foreach (i; 0..28) {
        c[0][i] = kp[i];
        d[0][i] = kp[i + 28];
    }
    foreach (i; 1..17) {
        c[i - 1].shiftLeft(SHIFTS[i - 1], 28, c[i]);
        d[i - 1].shiftLeft(SHIFTS[i - 1], 28, d[i]);
    }

    // merge 'd' into 'c'
    foreach (i; 1..17) {
        foreach (j; 28..56) {
            c[i][j] = d[i][j - 28];
        }
    }

    // form the sub-keys and store them in 'ks'
    BitArray[] ks;
    foreach (_; 0..17) {
        ks ~= bitArrayOfSize(48);
    }

    // permute 'c' using table PC2
    foreach (i; 1..17) {
        foreach (j; 0..48) {
            ks[i][j] = c[i][PC2[j] - 1];
        }
    }

    return ks;
}

private ubyte[] processMessage(const ubyte[] message, BitArray[] ks) {
    auto m = message.toBitArray();

    // permute 'message' using table IP
    auto mp = bitArrayOfSize(64);
    foreach (i; 0..64) {
        mp[i] = m[IP[i] - 1];
    }

    // split 'mp' in half and process the resulting series of 'l' and 'r
    BitArray[] left;
    BitArray[] right;
    foreach (_; 0..17) {
        left ~= bitArrayOfSize(32);
        right ~= bitArrayOfSize(32);
    }
    foreach (i; 0..32) {
        left[0][i] = mp[i];
        right[0][i] = mp[i + 32];
    }
    foreach (i; 1..17) {
        left[i] = right[i - 1];
        auto fs = f(right[i - 1], ks[i]);
        left[i - 1] ^= fs;
        right[i] = left[i - 1];
    }

    // amalgamate r[16] and l[16] (in that order) into 'e'
    auto e = bitArrayOfSize(64);
    foreach (i; 0..32) {
        e[i] = right[16][i];
    }
    foreach (i; 32..64) {
        e[i] = left[16][i - 32];
    }

    // permute 'e' using table IP2 ad return result as a hex string
    auto ep = bitArrayOfSize(64);
    foreach (i; 0..64) {
        ep[i] = e[IP2[i] - 1];
    }
    return ep.toByteArray();
}

private BitArray toBitArray(const ubyte[] byteArr) {
    auto bitArr = bitArrayOfSize(8 * byteArr.length);
    for (int i=0; i<byteArr.length; i++) {
        bitArr[8*i+0] = (byteArr[i] & 128) != 0;
        bitArr[8*i+1] = (byteArr[i] & 64) != 0;
        bitArr[8*i+2] = (byteArr[i] & 32) != 0;
        bitArr[8*i+3] = (byteArr[i] & 16) != 0;
        bitArr[8*i+4] = (byteArr[i] & 8) != 0;
        bitArr[8*i+5] = (byteArr[i] & 4) != 0;
        bitArr[8*i+6] = (byteArr[i] & 2) != 0;
        bitArr[8*i+7] = (byteArr[i] & 1) != 0;
    }
    return bitArr;
}

ubyte[] toByteArray(const ref BitArray bitArr) {
    auto len = bitArr.length / 8;
    ubyte[] byteArr = new ubyte[len];
    foreach (i; 0..len) {
        byteArr[i]  = bitArr[8 * i + 0] << 7;
        byteArr[i] |= bitArr[8 * i + 1] << 6;
        byteArr[i] |= bitArr[8 * i + 2] << 5;
        byteArr[i] |= bitArr[8 * i + 3] << 4;
        byteArr[i] |= bitArr[8 * i + 4] << 3;
        byteArr[i] |= bitArr[8 * i + 5] << 2;
        byteArr[i] |= bitArr[8 * i + 6] << 1;
        byteArr[i] |= bitArr[8 * i + 7] << 0;
    }
    return byteArr;
}

void shiftLeft(const ref BitArray self, int times, int len, ref BitArray output) {
    for (int i=0; i<=len; i++) {
        output[i] = self[i];
    }
    for (int t=1; t<=times; t++) {
        auto temp = output[0];
        for (int i=1; i<=len; i++) {
            output[i - 1] = output[i];
        }
        output[len - 1] = temp;
    }
}

private BitArray f(const ref BitArray r, const ref BitArray ks) {
    // permute 'r' using table E
    auto er = bitArrayOfSize(48);
    foreach (i; 0..48) {
        er[i] = r[E[i] - 1];
    }

    // xor 'er' with 'ks' and store back into 'er'
    er ^= ks;

    // process 'er' six bits at a time and store resulting four bits in 'sr'
    auto sr = bitArrayOfSize(32);
    foreach (i; 0..8) {
        auto j = i * 6;
        auto b = new int[6];
        foreach (k; 0..6) {
            b[k] = (er[j+k] != 0) ? 1 : 0;
        }
        auto row = 2 * b[0] + b[5];
        auto col = 8 * b[1] + 4 * b[2] + 2 * b[3] + b[4];
        int m = S[i][row * 16 + col];   // apply table s
        int n = 1;
        while (m > 0) {
            auto p = m % 2;
            sr[(i + 1) * 4 - n] = (p == 1);
            m /= 2;
            n++;
        }
    }

    // permute sr using table P
    auto sp = bitArrayOfSize(32);
    foreach (i; 0..32) {
        sp[i] = sr[P[i] - 1];
    }
    return sp;
}

void main() {
    immutable ubyte[][] keys = [
        [cast(ubyte)0x13, 0x34, 0x57, 0x79, 0x9B, 0xBC, 0xDF, 0xF1],
        [0x0E, 0x32, 0x92, 0x32, 0xEA, 0x6D, 0x0D, 0x73],
        [0x0E, 0x32, 0x92, 0x32, 0xEA, 0x6D, 0x0D, 0x73],
    ];

    immutable ubyte[][] messages = [
        [cast(ubyte)0x01, 0x23, 0x45, 0x67, 0x89, 0xAB, 0xCD, 0xEF],
        [0x87, 0x87, 0x87, 0x87, 0x87, 0x87, 0x87, 0x87],
        [0x59, 0x6F, 0x75, 0x72, 0x20, 0x6C, 0x69, 0x70,
		 0x73, 0x20, 0x61, 0x72, 0x65, 0x20, 0x73, 0x6D,
		 0x6F, 0x6F, 0x74, 0x68, 0x65, 0x72, 0x20, 0x74,
		 0x68, 0x61, 0x6E, 0x20, 0x76, 0x61, 0x73, 0x65,
		 0x6C, 0x69, 0x6E, 0x65, 0x0D, 0x0A],
    ];

    assert(keys.length == messages.length);

    foreach (i; 0..messages.length) {
        writefln("Key     : %(%02X%)", keys[i]);
        writefln("Message : %(%02X%)", messages[i]);

        ubyte[] encoded = encrypt(keys[i], messages[i]);
        writefln("Encoded : %(%02X%)", encoded);

        ubyte[] decoded = decrypt(keys[i], encoded);
        writefln("Decoded : %(%02X%)", decoded);

        writeln;
    }
}
