#include <stdio.h>
#include <stdbool.h>

bool three_3s(const int *items, size_t len) {
    int threes = 0;
    while (len--)
        if (*items++ == 3)
            if (threes<3) threes++;
            else return false;
        else if (threes != 0 && threes != 3)
            return false;
    return true;
}

void print_list(const int *items, size_t len) {
    while (len--) printf("%d ", *items++);
}

int main() {
    int lists[][9] = {
        {9,3,3,3,2,1,7,8,5},
        {5,2,9,3,3,6,8,4,1},
        {1,4,3,6,7,3,8,3,2},
        {1,2,3,4,5,6,7,8,9},
        {4,6,8,7,2,3,3,3,1}
    };

    size_t list_length = sizeof(lists[0]) / sizeof(int);
    size_t n_lists = sizeof(lists) / sizeof(lists[0]);

    for (size_t i=0; i<n_lists; i++) {
        print_list(lists[i], list_length);
        printf("-> %s\n", three_3s(lists[i], list_length) ? "true" : "false");
    }

    return 0;
}
