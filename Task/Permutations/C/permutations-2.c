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

    int k = factorial;
    while (k > 0) {
        printf("%s\n", arr);

        int i = 1;
        while (arr[i] > arr[i - 1]) {
            i++;
        }

        int j = 0;
        while (arr[j] < arr[i]) {
            j++;
        }

        swap(&arr[j], &arr[i]);
        i--;

        for (j = 0; j < i; i--, j++) {
            swap(&arr[i], &arr[j]);
        }

        k--;
    }
}

int compare(const void *a, const void *b) {
    return (int)(*(char *)b - *(char *)a); // descending order
}

int main(void) {
    char arr[ARR_SIZE + 1] = "2431";

    qsort(arr, ARR_SIZE, sizeof(char), compare); // "4321"
    permutations(arr, ARR_SIZE);

    return EXIT_SUCCESS;
}
