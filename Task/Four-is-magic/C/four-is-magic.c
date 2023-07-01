#include <stdint.h>
#include <stdio.h>
#include <glib.h>

typedef struct named_number_tag {
    const char* name;
    uint64_t number;
} named_number;

const named_number named_numbers[] = {
    { "hundred", 100 },
    { "thousand", 1000 },
    { "million", 1000000 },
    { "billion", 1000000000 },
    { "trillion", 1000000000000 },
    { "quadrillion", 1000000000000000ULL },
    { "quintillion", 1000000000000000000ULL }
};

const named_number* get_named_number(uint64_t n) {
    const size_t names_len = sizeof(named_numbers)/sizeof(named_number);
    for (size_t i = 0; i + 1 < names_len; ++i) {
        if (n < named_numbers[i + 1].number)
            return &named_numbers[i];
    }
    return &named_numbers[names_len - 1];
}

size_t append_number_name(GString* str, uint64_t n) {
    static const char* small[] = {
        "zero", "one", "two", "three", "four", "five", "six", "seven", "eight",
        "nine", "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen",
        "sixteen", "seventeen", "eighteen", "nineteen"
    };
    static const char* tens[] = {
        "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"
    };
    size_t len = str->len;
    if (n < 20) {
        g_string_append(str, small[n]);
    }
    else if (n < 100) {
        g_string_append(str, tens[n/10 - 2]);
        if (n % 10 != 0) {
            g_string_append_c(str, '-');
            g_string_append(str, small[n % 10]);
        }
    } else {
        const named_number* num = get_named_number(n);
        uint64_t p = num->number;
        append_number_name(str, n/p);
        g_string_append_c(str, ' ');
        g_string_append(str, num->name);
        if (n % p != 0) {
            g_string_append_c(str, ' ');
            append_number_name(str, n % p);
        }
    }
    return str->len - len;
}

GString* magic(uint64_t n) {
    GString* str = g_string_new(NULL);
    for (unsigned int i = 0; ; ++i) {
        size_t count = append_number_name(str, n);
        if (i == 0)
            str->str[0] = g_ascii_toupper(str->str[0]);
        if (n == 4) {
            g_string_append(str, " is magic.");
            break;
        }
        g_string_append(str, " is ");
        append_number_name(str, count);
        g_string_append(str, ", ");
        n = count;
    }
    return str;
}

void test_magic(uint64_t n) {
    GString* str = magic(n);
    printf("%s\n", str->str);
    g_string_free(str, TRUE);
}

int main() {
    test_magic(5);
    test_magic(13);
    test_magic(78);
    test_magic(797);
    test_magic(2739);
    test_magic(4000);
    test_magic(7893);
    test_magic(93497412);
    test_magic(2673497412U);
    test_magic(10344658531277200972ULL);
    return 0;
}
