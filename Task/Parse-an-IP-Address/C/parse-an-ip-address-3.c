#include <arpa/inet.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

typedef struct ip_address_tag {
    union {
        uint8_t address_v6[16];
        uint32_t address_v4;
    } address;
    uint16_t family;
    uint16_t port;
} ip_address_t;

bool parse_ipv4_address(const char* input, ip_address_t* result) {
    struct in_addr addr;
    if (inet_pton(AF_INET, input, &addr) == 1) {
        result->family = AF_INET;
        result->address.address_v4 = ntohl(addr.s_addr);
        result->port = 0;
        return true;
    }
    return false;
}

bool parse_ipv6_address(const char* input, ip_address_t* result) {
    struct in6_addr addr;
    if (inet_pton(AF_INET6, input, &addr) == 1) {
        result->family = AF_INET6;
        memcpy(result->address.address_v6, addr.s6_addr, 16);
        result->port = 0;
        return true;
    }
    return false;
}

uint16_t parse_port_number(const char* str) {
    char* eptr;
    unsigned long port = strtoul(str, &eptr, 10);
    if (port > 0 && *eptr == '\0' && port <= UINT16_MAX)
        return (uint16_t)port;
    return 0;
}

//
// Parse an IP address and port from the given input string.
// Returns false if the input is not valid.
//
// Valid formats are:
// [ipv6_address]:port
// ipv4_address:port
// ipv4_address
// ipv6_address
//
bool parse_address(const char* input, ip_address_t* result) {
    char* ptr = strrchr(input, ':');
    if (ptr != NULL && ptr > input) {
        uint16_t port = parse_port_number(ptr + 1);
        if (port > 0) {
            bool success = false;
            char* copy = strdup(input);
            if (copy == NULL)
                return false;
            int index = ptr - input;
            copy[index] = '\0';
            if (copy[index - 1] == ']' && copy[0] == '[') {
                copy[index - 1] = '\0';
                if (parse_ipv6_address(copy + 1, result))
                    success = true;
            } else if (parse_ipv4_address(copy, result)) {
                success = true;
            }
            free(copy);
            if (success) {
                result->port = port;
                return true;
            }
        }
    }
    return parse_ipv6_address(input, result)
        || parse_ipv4_address(input, result);
}

void test_parse_address(const char* input) {
    printf("input: %s\n", input);
    ip_address_t result;
    if (parse_address(input, &result)) {
        printf("address family: %s\n",
               result.family == AF_INET ? "IPv4" : "IPv6");
        if (result.family == AF_INET)
            printf("address: %X", result.address.address_v4);
        else if (result.family == AF_INET6) {
            printf("address: ");
            for (int i = 0; i < 16; ++i)
                printf("%02X", (unsigned int)result.address.address_v6[i]);
        }
        printf("\n");
        if (result.port > 0)
            printf("port: %hu\n", result.port);
        else
            printf("port not specified\n");
    } else {
        printf("Parsing failed.\n");
    }
    printf("\n");
}

int main() {
    test_parse_address("127.0.0.1");
    test_parse_address("127.0.0.1:80");
    test_parse_address("::ffff:127.0.0.1");
    test_parse_address("::1");
    test_parse_address("[::1]:80");
    test_parse_address("1::80");
    test_parse_address("2605:2700:0:3::4713:93e3");
    test_parse_address("[2605:2700:0:3::4713:93e3]:80");
    return 0;
}
