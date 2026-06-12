#include <iomanip>
#include <iostream>
#include <sstream>
using namespace std;

enum CipherMode {ENCRYPT, DECRYPT};

// External results
uint32_t randRsl[256];
uint32_t randCnt;

// Internal state
uint32_t mm[256];
uint32_t aa = 0, bb = 0, cc = 0;

void isaac()
{
    ++cc;  // cc just gets incremented once per 256 results
    bb += cc; // then combined with bb

    for (uint32_t i = 0; i < 256; ++i)
    {
        uint32_t x, y;

        x = mm[i];
        switch (i % 4)
        {
            case 0:
                aa = aa ^ (aa << 13);
                break;
            case 1:
                aa = aa ^ (aa >> 6);
                break;
            case 2:
                aa = aa ^ (aa << 2);
                break;
            case 3:
                aa = aa ^ (aa >> 16);
                break;
        }
        aa = mm[(i + 128) % 256] + aa;
        y = mm[(x >> 2) % 256] + aa + bb;
        mm[i] = y;
        bb = mm[(y >> 10) % 256] + x;
        randRsl[i] = bb;
    }
    randCnt = 0; // Prepare to use the first set of results.
}

void mix(uint32_t a[])
{
    a[0] = a[0] ^ a[1] << 11; a[3] += a[0]; a[1] += a[2];
    a[1] = a[1] ^ a[2] >>  2; a[4] += a[1]; a[2] += a[3];
    a[2] = a[2] ^ a[3] <<  8; a[5] += a[2]; a[3] += a[4];
    a[3] = a[3] ^ a[4] >> 16; a[6] += a[3]; a[4] += a[5];
    a[4] = a[4] ^ a[5] << 10; a[7] += a[4]; a[5] += a[6];
    a[5] = a[5] ^ a[6] >>  4; a[0] += a[5]; a[6] += a[7];
    a[6] = a[6] ^ a[7] <<  8; a[1] += a[6]; a[7] += a[0];
    a[7] = a[7] ^ a[0] >>  9; a[2] += a[7]; a[0] += a[1];
}

void randInit(bool flag)
{
    uint32_t a[8];
    aa = bb = cc = 0;

    a[0] = 2654435769UL; // 0x9e3779b9: the golden ratio
    for (uint32_t j = 1; j < 8; ++j)
        a[j] = a[0];

    for (uint32_t i = 0; i < 4; ++i) // Scramble it.
        mix(a);
    for (uint32_t i = 0; i < 256; i += 8) // Fill in mm[] with messy stuff.
    {
        if (flag) // Use all the information in the seed.
            for (uint32_t j = 0; j < 8; ++j)
                a[j] += randRsl[i + j];
        mix(a);
        for (uint32_t j = 0; j < 8; ++j)
            mm[i + j] = a[j];
    }

    if (flag)
    {   // Do a second pass to make all of the seed affect all of mm.
        for (uint32_t i = 0; i < 256; i += 8)
        {
            for (uint32_t j = 0; j < 8; ++j)
                a[j] += mm[i + j];
            mix(a);
            for (uint32_t j = 0; j < 8; ++j)
                mm[i + j] = a[j];
        }
    }
    isaac(); // Fill in the first set of results.
    randCnt = 0; // Prepare to use the first set of results.
}

// Seed ISAAC with a given string.
// The string can be any size. The first 256 values will be used.
void seedIsaac(string seed, bool flag)
{
    uint32_t seedLength = seed.length();
    for (uint32_t i = 0; i < 256; i++)
        mm[i] = 0;
    for (uint32_t i = 0; i < 256; i++)
        // In case seed has less than 256 elements
        randRsl[i] = i > seedLength ? 0 : seed[i];
    // Initialize ISAAC with seed
    randInit(flag);
}

// Get a random 32-bit value 0..MAXINT
uint32_t getRandom32Bit()
{
    uint32_t result = randRsl[randCnt];
    ++randCnt;
    if (randCnt > 255)
    {
        isaac();
        randCnt = 0;
    }
    return result;
}

// Get a random character in printable ASCII range
char getRandomChar()
{
    return getRandom32Bit() % 95 + 32;
}

// Convert an ASCII string to a hexadecimal string.
string ascii2hex(string source)
{
    uint32_t sourceLength = source.length();
    stringstream ss;
    for (uint32_t i = 0; i < sourceLength; i++)
        ss << setfill ('0') << setw(2) << hex << (int) source[i];
    return ss.str();
}

// XOR encrypt on random stream.
string vernam(string msg)
{
    uint32_t msgLength = msg.length();
    string destination = msg;
    for (uint32_t i = 0; i < msgLength; i++)
        destination[i] = getRandomChar() ^ msg[i];
    return destination;
}

// Caesar-shift a character <shift> places: Generalized Vigenere
char caesar(CipherMode m, char ch, char shift, char modulo, char start)
{
    int n;
    if (m == DECRYPT)
        shift = -shift;
    n = (ch - start) + shift;
    n %= modulo;
    if (n < 0)
        n += modulo;
    return start + n;
}

// Vigenere mod 95 encryption & decryption.
string vigenere(string msg, CipherMode m)
{
    uint32_t msgLength = msg.length();
    string destination = msg;
    // Caesar-shift message
    for (uint32_t i = 0; i < msgLength; ++i)
        destination[i] = caesar(m, msg[i], getRandomChar(), 95, ' ');
    return destination;
}

int main()
{
    // TASK globals
    string msg = "a Top Secret secret";
    string key = "this is my secret key";
    string xorCipherText, modCipherText, xorPlainText, modPlainText;

    // (1) Seed ISAAC with the key
    seedIsaac(key, true);
    // (2) Encryption
    // (a) XOR (Vernam)
    xorCipherText = vernam(msg);
    // (b) MOD (Vigenere)
    modCipherText = vigenere(msg, ENCRYPT);
    // (3) Decryption
    seedIsaac(key, true);
    // (a) XOR (Vernam)
    xorPlainText = vernam(xorCipherText);
    // (b) MOD (Vigenere)
    modPlainText = vigenere(modCipherText, DECRYPT);
    // Program output
    cout << "Message: " << msg << endl;
    cout << "Key    : " << key << endl;
    cout << "XOR    : " << ascii2hex(xorCipherText) << endl;
    cout << "MOD    : " << ascii2hex(modCipherText) << endl;
    cout << "XOR dcr: " << xorPlainText << endl;
    cout << "MOD dcr: " << modPlainText << endl;
}
