#include <stdio.h>
#include <string.h>

void swap(char* p1, char* p2, size_t size) {
    for (; size-- > 0; ++p1, ++p2) {
        char tmp = *p1;
        *p1 = *p2;
        *p2 = tmp;
    }
}

void cocktail_shaker_sort(void* base, size_t count, size_t size,
                          int (*cmp)(const void*, const void*)) {
    char* begin = base;
    char* end = base + size * count;
    if (end == begin)
        return;
    for (end -= size; begin < end; ) {
        char* new_begin = end;
        char* new_end = begin;
        for (char* p = begin; p < end; p += size) {
            char* q = p + size;
            if (cmp(p, q) > 0) {
                swap(p, q, size);
                new_end = p;
            }
        }
        end = new_end;
        for (char* p = end; p > begin; p -= size) {
            char* q = p - size;
            if (cmp(q, p) > 0) {
                swap(p, q, size);
                new_begin = p;
            }
        }
        begin = new_begin;
    }
}

int string_compare(const void* p1, const void* p2) {
    const char* const* s1 = p1;
    const char* const* s2 = p2;
    return strcmp(*s1, *s2);
}

void print(const char** a, size_t len) {
    for (size_t i = 0; i < len; ++i)
        printf("%s ", a[i]);
    printf("\n");
}

int main() {
    const char* a[] = { "one", "two", "three", "four", "five",
        "six", "seven", "eight" };
    const size_t len = sizeof(a)/sizeof(a[0]);
    printf("before: ");
    print(a, len);
    cocktail_shaker_sort(a, len, sizeof(char*), string_compare);
    printf("after: ");
    print(a, len);
    return 0;
}
