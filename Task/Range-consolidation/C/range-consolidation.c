#include <stdio.h>
#include <stdlib.h>

typedef struct range_tag {
    double low;
    double high;
} range_t;

void normalize_range(range_t* range) {
    if (range->high < range->low) {
        double tmp = range->low;
        range->low = range->high;
        range->high = tmp;
    }
}

int range_compare(const void* p1, const void* p2) {
    const range_t* r1 = p1;
    const range_t* r2 = p2;
    if (r1->low < r2->low)
        return -1;
    if (r1->low > r2->low)
        return 1;
    if (r1->high < r2->high)
        return -1;
    if (r1->high > r2->high)
        return 1;
    return 0;
}

void normalize_ranges(range_t* ranges, size_t count) {
    for (size_t i = 0; i < count; ++i)
        normalize_range(&ranges[i]);
    qsort(ranges, count, sizeof(range_t), range_compare);
}

// Consolidates an array of ranges in-place. Returns the
// number of ranges after consolidation.
size_t consolidate_ranges(range_t* ranges, size_t count) {
    normalize_ranges(ranges, count);
    size_t out_index = 0;
    for (size_t i = 0; i < count; ) {
        size_t j = i;
        while (++j < count && ranges[j].low <= ranges[i].high) {
            if (ranges[i].high < ranges[j].high)
                ranges[i].high = ranges[j].high;
        }
        ranges[out_index++] = ranges[i];
        i = j;
    }
    return out_index;
}

void print_range(const range_t* range) {
    printf("[%g, %g]", range->low, range->high);
}

void print_ranges(const range_t* ranges, size_t count) {
    if (count == 0)
        return;
    print_range(&ranges[0]);
    for (size_t i = 1; i < count; ++i) {
        printf(", ");
        print_range(&ranges[i]);
    }
}

void test_consolidate_ranges(range_t* ranges, size_t count) {
    print_ranges(ranges, count);
    printf(" -> ");
    count = consolidate_ranges(ranges, count);
    print_ranges(ranges, count);
    printf("\n");
}

#define LENGTHOF(a) sizeof(a)/sizeof(a[0])

int main() {
    range_t test1[] = { {1.1, 2.2} };
    range_t test2[] = { {6.1, 7.2}, {7.2, 8.3} };
    range_t test3[] = { {4, 3}, {2, 1} };
    range_t test4[] = { {4, 3}, {2, 1}, {-1, -2}, {3.9, 10} };
    range_t test5[] = { {1, 3}, {-6, -1}, {-4, -5}, {8, 2}, {-6, -6} };
    test_consolidate_ranges(test1, LENGTHOF(test1));
    test_consolidate_ranges(test2, LENGTHOF(test2));
    test_consolidate_ranges(test3, LENGTHOF(test3));
    test_consolidate_ranges(test4, LENGTHOF(test4));
    test_consolidate_ranges(test5, LENGTHOF(test5));
    return 0;
}
