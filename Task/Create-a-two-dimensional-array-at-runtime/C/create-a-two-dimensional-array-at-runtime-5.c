#include <stdio.h>
#include <alloca.h>
int main(int argc, char **argv)
{
   int user1 = 0, user2 = 0;
   int *a1, **array, row;

   printf("Enter two integers.  Space delimited, please:  ");
   scanf("%d %d",&user1, &user2);

   a1 = alloca(user1*user2*sizeof(int));
   array = alloca(user1*sizeof(int*));
   for (row=0; row<user1; row++) array[row]=a1+row*user2;

   array[user1/2][user2/2] = user1 + user2;
   printf("array[%d][%d] is %d\n",user1/2,user2/2,array[user1/2][user2/2]);
   return 0;
}
