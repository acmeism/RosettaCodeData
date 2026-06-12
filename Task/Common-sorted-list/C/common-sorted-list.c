#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define COUNTOF(a) (sizeof(a)/sizeof(a[0]))

void fatal(const char* message) {
    fprintf(stderr, "%s\n", message);
    exit(1);
}

void* xmalloc(size_t n) {
    void* ptr = malloc(n);
    if (ptr == NULL)
        fatal("Out of memory");
    return ptr;
}

int icompare(const void* p1, const void* p2) {
    const int* ip1 = p1;
    const int* ip2 = p2;
    return (*ip1 < *ip2) ? -1 : ((*ip1 > *ip2) ? 1 : 0);
}

size_t unique(int* array, size_t len) {
    size_t out_index = 0;
    int prev;
    for (size_t i = 0; i < len; ++i) {
        if (i == 0 || prev != array[i])
            array[out_index++] = array[i];
        prev = array[i];
    }
    return out_index;
}

int* common_sorted_list(const int** arrays, const size_t* lengths, size_t count, size_t* size) {
    size_t len = 0;
    for (size_t i = 0; i < count; ++i)
        len += lengths[i];
    int* array = xmalloc(len * sizeof(int));
    for (size_t i = 0, offset = 0; i < count; ++i) {
        memcpy(array + offset, arrays[i], lengths[i] * sizeof(int));
        offset += lengths[i];
    }
    qsort(array, len, sizeof(int), icompare);
    *size = unique(array, len);
    return array;
}

void print(const int* array, size_t len) {
    printf("[");
    for (size_t i = 0; i < len; ++i) {
        if (i > 0)
            printf(", ");
        printf("%d", array[i]);
    }
    printf("]\n");
}

int main() {
    const int a[] = {5, 1, 3, 8, 9, 4, 8, 7};
    const int b[] = {3, 5, 9, 8, 4};
    const int c[] = {1, 3, 7, 9};
    size_t len = 0;
    const int* arrays[] = {a, b, c};
    size_t lengths[] = {COUNTOF(a), COUNTOF(b), COUNTOF(c)};
    int* sorted = common_sorted_list(arrays, lengths, COUNTOF(arrays), &len);
    print(sorted, len);
    free(sorted);
    return 0;
}
