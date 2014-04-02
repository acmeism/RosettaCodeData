#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MAX_ELEMENTS 1000000

/* Return the k-th smallest item in array x of length len */
double quick_select(int k, double *x, int len)
{
   inline void swap(int a, int b)
   {
      double t = x[a];
      x[a] = x[b], x[b] = t;
   }

   int left = 0, right = len - 1;
   int pos, i;
   double pivot;

   while (left < right)
   {
      pivot = x[k];
      swap(k, right);
      for (i = pos = left; i < right; i++)
      {
         if (x[i] < pivot)
         {
            swap(i, pos);
            pos++;
         }
      }
      swap(right, pos);
      if (pos == k) break;
      if (pos < k) left = pos + 1;
      else right = pos - 1;
   }
   return x[k];
}

int main(void)
{
   int i, length;
   double *x, median;

   /* Initialize random length double array with random doubles */
   srandom(time(0));
   length = random() % MAX_ELEMENTS;
   x = malloc(sizeof(double) * length);
   for (i = 0; i < length; i++)
   {
      // shifted by RAND_MAX for negative values
      // divide by a random number for floating point
      x[i] = (double)(random() - RAND_MAX / 2) / (random() + 1); // + 1 to not divide by 0
   }


   if (length % 2 == 0) // Even number of elements, median is average of middle two
   {
      median = (quick_select(length / 2, x, length) + quick_select(length / 2 - 1, x, length / 2)) / 2;
   }
   else // select middle element
   {
      median = quick_select(length / 2, x, length);
   }


   /* Sanity testing of median */
   int less = 0, more = 0, eq = 0;
   for (i = 0; i < length; i++)
   {
      if (x[i] < median) less ++;
      else if (x[i] > median) more ++;
      else eq ++;
   }
   printf("length: %d\nmedian: %lf\n<: %d\n>: %d\n=: %d\n", length, median, less, more, eq);

   free(x);
   return 0;
}
