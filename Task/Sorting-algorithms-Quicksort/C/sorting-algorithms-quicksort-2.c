#include <stdlib.h>     // REQ: rand()

void swap(int *a, int *b) {
  int c = *a;
  *a = *b;
  *b = c;
}

int partition(int A[], int p, int q) {
  swap(&A[p + (rand() % (q - p + 1))], &A[q]);   // PIVOT = A[q]

  int i = p - 1;
  for(int j = p; j <= q; j++) {
    if(A[j] <= A[q]) {
      swap(&A[++i], &A[j]);
    }
  }

  return i;
}

void quicksort(int A[], int p, int q) {
  if(p < q) {
    int pivotIndx = partition(A, p, q);

    quicksort(A, p, pivotIndx - 1);
    quicksort(A, pivotIndx + 1, q);
  }
}
