#include <stdio.h>

int main(int argc, char **argv) {

   int user1 = 0, user2 = 0;
   printf("Enter two integers.  Space delimited, please:  ");
   scanf("%d %d",&user1, &user2);
   int array[user1][user2];
   array[user1/2][user2/2] = user1 + user2;
   printf("array[%d][%d] is %d\n",user1/2,user2/2,array[user1/2][user2/2]);

   return 0;
}
