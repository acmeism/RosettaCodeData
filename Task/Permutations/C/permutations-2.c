#include <stdio.h>
int main() {
        char a[] = "4321";
        int fact = 24;
           int i, j;
           int y=0;
           char c;
          while (y != fact) {
          printf("%s\n", a);
          i=1;
          while(a[i] > a[i-1]) i++;
          j=0;
          while(a[j] < a[i])j++;
      c=a[j];
      a[j]=a[i];
      a[i]=c;
i--;
for (j = 0; j < i; i--, j++) {
  c = a[i];
  a[i] = a[j];
  a[j] = c;
      }
y++;
   }
}
