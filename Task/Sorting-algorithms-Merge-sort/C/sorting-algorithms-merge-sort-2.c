#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* x and y are sorted, copy nx+ny sorted values to r */
void merge(int nx, int*x, int ny, int*y, int*r) {
    int i= 0, j= 0, k= 0;
    while (i<nx && j<ny) {
        int a= x[i], b= y[j];
        if (a<b) {
            r[k++]= a;
            i++;
        } else {
            r[k++]= b;
            j++;
        }
    }
    if (i<nx) {
        memcpy(r+k, i+x, (nx-i)*sizeof (int));
    } else if (j<ny) {
        memcpy(r+k, j+y, (ny-j)*sizeof (int));
    }
}

void mergesort(int ny, int *y) {
    int stride= 1, mid, *r= y, *t, *x= malloc(ny*sizeof (int));
    while (stride < ny) {
        stride= 2*(mid= stride);
        for (int i= 0; i<ny; i+= stride) {
            int lim= mid;
            if (i+stride >= ny) {
                if (i+mid >= ny) {
                    memcpy(i+x, i+y, (ny-i)*sizeof (int));
                    continue;
                }
                lim= ny-(i+mid);
            }
            merge(mid, i+y, lim, i+mid+y, i+x);
        }
        t= x; x= y; y=t;
    }
    if (y!=r) {
        memcpy(r, y, ny*sizeof(int));
        x= y;
    }
    free(x);
}

int main () {
    int a[] = {4, 65, 2, -31, 0, 99, 2, 83, 782, 1};
    int n = sizeof a / sizeof a[0];
    int i;
    for (i = 0; i < n; i++)
        printf("%d%s", a[i], i == n - 1 ? "\n" : " ");
    mergesort(n, a);
    for (i = 0; i < n; i++)
        printf("%d%s", a[i], i == n - 1 ? "\n" : " ");
    return 0;
}
