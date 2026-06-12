#include <stdio.h>
#include <stdlib.h>

typedef long long int64;

void to_word(char *ws, int64 w) {
    sprintf(ws, "W%05lld", w);
}

int64 from_word(char *ws) {
    return atoi(++ws);
}

int main() {
    double lat, lon;
    int64 latlon, ilat, ilon, w1, w2, w3;
    char w1s[7], w2s[7], w3s[7];
    printf("Starting figures:\n");
    lat = 28.3852;
    lon = -81.5638;
    printf("  latitude = %0.4f, longitude = %0.4f\n", lat, lon);

    // convert lat and lon to positive integers
    ilat = (int64)(lat*10000 + 900000);
    ilon = (int64)(lon*10000 + 1800000);

    // build 43 bit BigInt comprising 21 bits (lat) and 22 bits (lon)
    latlon = (ilat << 22) + ilon;

    // isolate relevant bits
    w1 = (latlon >> 28) & 0x7fff;
    w2 = (latlon >> 14) & 0x3fff;
    w3 = latlon & 0x3fff;

    // convert to word format
    to_word(w1s, w1);
    to_word(w2s, w2);
    to_word(w3s, w3);

    // and print the results
    printf("\nThree word location is:\n");
    printf("  %s %s %s\n", w1s, w2s, w3s);

    /* now reverse the procedure */
    w1 = from_word(w1s);
    w2 = from_word(w2s);
    w3 = from_word(w3s);

    latlon = (w1 << 28) | (w2 << 14) | w3;
    ilat = latlon >> 22;
    ilon = latlon & 0x3fffff;
    lat = (double)(ilat-900000) / 10000;
    lon = (double)(ilon-1800000) / 10000;

    // and print the results
    printf("\nAfter reversing the procedure:\n");
    printf("  latitude = %0.4f, longitude = %0.4f\n", lat, lon);
    return 0;
}
