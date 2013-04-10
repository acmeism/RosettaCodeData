#include <stdio.h>
#include <stdlib.h>
int main(int argc, char **argv)
{
   int user1 = 0;
   int space_needed;
   int *a1, **array;
   int row, col;

   printf("Enter size of array:  ");
   scanf("%d",&user1);

   space_needed = (user1+1)*user1/2;
   a1 = malloc(space_needed);
   array = malloc(user1*sizeof(int*));
   for (row=0,offset=0; row<user1; offset+=(user1-row), row++) {
      array[row]=a1+offset-row;
      for (col=row; col<user1; col++)
          array[row][col] = 1+col-row;
   }
   for (row=0; row<user1; row++)
      printf("%d ", array[row][user1-1]);
   printf("\n");

   free(array);
   free(a1);
   return 0;
}
