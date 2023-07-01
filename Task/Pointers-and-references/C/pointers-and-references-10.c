#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int val;
} num;

int addNodes(num **array, int elems);

int main(void) {
    int numElems, i;
    num *arr = NULL;
    numElems = addNodes(&arr, 10);
    for (i = 0; i < numElems; i++) {
        printf("%d) %d\n", i+1, arr[i].val);
    }
    free(arr);
    return 0;
}

int addNodes(num **array, int elems) {
    num *temp = NULL;
    int i;
    for (i = 0; i < elems; i++) {
        temp = realloc(*array, (i+1) * sizeof **array);
        if (temp == NULL) {
            free(*array); return -1;
        } else {
            *array = temp;
        }
        (*array)[i].val = i;
        // Alternatives:
        // ((*array)+i)->val = i; // or
        // (*((*array)+i)).val = i;
    }
    return i;
}
