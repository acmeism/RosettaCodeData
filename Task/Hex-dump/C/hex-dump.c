#include <ctype.h>
#include <errno.h>
#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#define BYTES_HEX 16
#define BYTES_BIN 6

static void print_hex(const char* data, long count) {
    long i = 0;
    for (; i < count; ++i) {
        if (i % 8 == 0)
            putchar(' ');
        printf(" %02x", (unsigned char)data[i]);
    }
    for (; i < BYTES_HEX; ++i) {
        if (i % 8 == 0)
            putchar(' ');
        printf("   ");
    }
}

static void print_binary(const char* data, long count) {
    long i = 0;
    putchar(' ');
    for (; i < count; ++i) {
        unsigned char c = data[i];
        putchar(' ');
        for (unsigned char m = 1 << 7; m != 0; m >>= 1)
            putchar((c & m) ? '1' : '0');
    }
    for (; i < BYTES_BIN; ++i)
        printf("         ");
}

static void print_chars(const char* data, long count) {
    for (long i = 0; i < count; ++i) {
        unsigned char c = data[i];
        putchar(isprint(c) ? c : '.');
    }
}

static bool string_to_long(const char* str, long* value) {
    char* eptr;
    long result = strtol(str, &eptr, 0);
    if (errno || *eptr || result < 0)
        return false;
    *value = result;
    return true;
}

static void usage(const char* program) {
    fprintf(stderr, "usage: %s [-b] [-s skip] [-n length] filename\n", program);
}

int main(int argc, char** argv) {
    long offset = 0;
    long max_length = LONG_MAX;
    bool binary = false;
    int i = 1;
    for (; i < argc && argv[i][0] == '-'; ++i) {
        switch (argv[i][1]) {
        case 's':
            if (++i == argc) {
                usage(argv[0]);
                return EXIT_FAILURE;
            }
            if (!string_to_long(argv[i], &offset)) {
                fprintf(stderr, "Invalid skip '%s'.\n", argv[i]);
                return EXIT_FAILURE;
            }
            break;
        case 'n':
            if (++i == argc) {
                usage(argv[0]);
                return EXIT_FAILURE;
            }
            if (!string_to_long(argv[i], &max_length)) {
                fprintf(stderr, "Invalid length '%s'.\n", argv[i]);
                return EXIT_FAILURE;
            }
            break;
        case 'b':
            binary = true;
            break;
        default:
            usage(argv[0]);
            return EXIT_FAILURE;
        }
    }
    if (i + 1 != argc) {
        usage(argv[0]);
        return EXIT_FAILURE;
    }
    FILE* fp = fopen(argv[i], "rb");
    if (!fp) {
        perror(argv[i]);
        return EXIT_FAILURE;
    }
    if (fseek(fp, 0, SEEK_END)) {
        perror("fseek");
        fclose(fp);
        return EXIT_FAILURE;
    }
    long max_offset = ftell(fp);
    if (offset > max_offset)
        offset = max_offset;
    if (fseek(fp, offset, SEEK_SET)) {
        perror("fseek");
        fclose(fp);
        return EXIT_FAILURE;
    }
    char data[BYTES_HEX];
    const long max_count = binary ? BYTES_BIN : BYTES_HEX;
    for (long length = 0; length <= max_length;) {
        printf("%08lx", offset);
        long count = fread(data, 1, max_count, fp);
        if (count > max_length - length)
            count = max_length - length;
        if (count == 0) {
            putchar('\n');
            break;
        }
        if (binary)
            print_binary(data, count);
        else
            print_hex(data, count);
        printf("  |");
        print_chars(data, count);
        printf("|\n");
        offset += count;
        length += count;
    }
    fclose(fp);
    return EXIT_SUCCESS;
}
