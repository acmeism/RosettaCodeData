#include <stdio.h>
int main (int argc, char *argv[]) {
//here we check arguments
	if (argc < 2) {
        printf("Enter an argument. Example 1234 or dcba:\n");
        return 0;
	}
//it calculates an array's length
        int x;
        for (x = 0; argv[1][x] != '\0'; x++);
//buble sort the array
	int f, v, m;
	 for(f=0; f < x; f++) {
    	 for(v = x-1; v > f; v-- ) {
     	 if (argv[1][v-1] > argv[1][v]) {
	m=argv[1][v-1];
	argv[1][v-1]=argv[1][v];
	argv[1][v]=m;
    }
  }
}

//it calculates a factorial to stop the algorithm
    char a[x];
	int k=0;
	int fact=k+1;
             while (k!=x) {
                   a[k]=argv[1][k];
               	   k++;
		  fact = k*fact;
                   }
                   a[k]='\0';
//Main part: here we permutate
           int i, j;
           int y=0;
           char c;
          while (y != fact) {
          printf("%s\n", a);
          i=x-2;
          while(a[i] > a[i+1] ) i--;
          j=x-1;
          while(a[j] < a[i] ) j--;
      c=a[j];
      a[j]=a[i];
      a[i]=c;
i++;
for (j = x-1; j > i; i++, j--) {
  c = a[i];
  a[i] = a[j];
  a[j] = c;
      }
y++;
   }
}
