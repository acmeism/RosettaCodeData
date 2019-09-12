#include <stdio.h>
#include <stdlib.h>

void counting_sort_mm(int *array, int n, int min, int max)
{
  int i, j, z;

  int range = max - min + 1;
  int *count = malloc(range * sizeof(*array));

  for(i = 0; i < range; i++) count[i] = 0;
  for(i = 0; i < n; i++) count[ array[i] - min ]++;

  for(i = min, z = 0; i <= max; i++) {
    for(j = 0; j < count[i - min]; j++) {
      array[z++] = i;
    }
  }

  free(count);
}

void min_max(int *array, int n, int *min, int *max)
{
  int i;

  *min = *max = array[0];
  for(i=1; i < n; i++) {
    if ( array[i] < *min ) {
      *min = array[i];
    } else if ( array[i] > *max ) {
      *max = array[i];
    }
  }
}
