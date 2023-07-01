#include <stdio.h>

void insertion_sort(int*, const size_t);

void insertion_sort(int *a, const size_t n) {
	for(size_t i = 1; i < n; ++i) {
		int key = a[i];
		size_t j = i;
		while( (j > 0) && (key < a[j - 1]) ) {
			a[j] = a[j - 1];
			--j;
		}
		a[j] = key;
	}
}

int main (int argc, char** argv) {

    int a[] = {4, 65, 2, -31, 0, 99, 2, 83, 782, 1};

    const size_t n = sizeof(a) / sizeof(a[0]) ;   // array extent

    for (size_t i = 0; i < n; i++)
        printf("%d%s", a[i], (i == (n - 1))? "\n" : " ");

    insertion_sort(a, n);

    for (size_t i = 0; i < n; i++)
        printf("%d%s", a[i], (i == (n - 1))? "\n" : " ");

    return 0;
}
