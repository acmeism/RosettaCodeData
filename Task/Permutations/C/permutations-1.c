#include <stdio.h>
#include <stdlib.h>

#define ARR_SIZE 4

int ifactorial(int n) {
    if (n == 0) {
        return 1;
    }

    int result = 1;

    for (int i = 1; i <= n; i++) {
        result *= i;
    }

    return result;
}

void swap(char *a, char *b) {
    char tmp = *a;
    *a = *b;
    *b = tmp;
}

void permutations(char *arr, int arr_size) {
    int factorial = ifactorial(arr_size);

    int k = 0;
    while (k < factorial) {
        printf("%s\n", arr);

        int i = arr_size - 2;
        while (arr[i] > arr[i + 1]) {
            i--;
        }

        int j = arr_size - 1;
        while (arr[j] < arr[i]) {
            j--;
        }

        swap(&arr[j], &arr[i]);
        i++;

        for (j = arr_size - 1; j > i; i++, j--) {
            swap(&arr[i], &arr[j]);
        }

        k++;
    }
}

int compare(const void *a, const void *b) {
    return (int)(*(char *)a - *(char *)b); // ascending order
}

int main(void) {
    char arr[ARR_SIZE + 1] = "dbac";

    qsort(arr, ARR_SIZE, sizeof(char), compare); // "abcd"
    permutations(arr, ARR_SIZE);

    return EXIT_SUCCESS;
}
