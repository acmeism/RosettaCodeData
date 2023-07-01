#include <stdbool.h>
#include <stdio.h>
#include <stdint.h>

typedef struct cidr_tag {
    uint32_t address;
    unsigned int mask_length;
} cidr_t;

// Convert a string in CIDR format to an IPv4 address and netmask,
// if possible. Also performs CIDR canonicalization.
bool cidr_parse(const char* str, cidr_t* cidr) {
    int a, b, c, d, m;
    if (sscanf(str, "%d.%d.%d.%d/%d", &a, &b, &c, &d, &m) != 5)
        return false;
    if (m < 1 || m > 32
        || a < 0 || a > UINT8_MAX
        || b < 0 || b > UINT8_MAX
        || c < 0 || c > UINT8_MAX
        || d < 0 || d > UINT8_MAX)
        return false;
    uint32_t mask = ~((1 << (32 - m)) - 1);
    uint32_t address = (a << 24) + (b << 16) + (c << 8) + d;
    address &= mask;
    cidr->address = address;
    cidr->mask_length = m;
    return true;
}

// Write a string in CIDR notation into the supplied buffer.
void cidr_format(const cidr_t* cidr, char* str, size_t size) {
    uint32_t address = cidr->address;
    unsigned int d = address & UINT8_MAX;
    address >>= 8;
    unsigned int c = address & UINT8_MAX;
    address >>= 8;
    unsigned int b = address & UINT8_MAX;
    address >>= 8;
    unsigned int a = address & UINT8_MAX;
    snprintf(str, size, "%u.%u.%u.%u/%u", a, b, c, d,
             cidr->mask_length);
}

int main(int argc, char** argv) {
    const char* tests[] = {
        "87.70.141.1/22",
        "36.18.154.103/12",
        "62.62.197.11/29",
        "67.137.119.181/4",
        "161.214.74.21/24",
        "184.232.176.184/18"
    };
    for (int i = 0; i < sizeof(tests)/sizeof(tests[0]); ++i) {
        cidr_t cidr;
        if (cidr_parse(tests[i], &cidr)) {
            char out[32];
            cidr_format(&cidr, out, sizeof(out));
            printf("%-18s -> %s\n", tests[i], out);
        } else {
            fprintf(stderr, "%s: invalid CIDR\n", tests[i]);
        }
    }
    return 0;
}
