#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(){
   char array[] = { 'a', 'b', 'c','d','e','f','g','h','i','j' };
   int i;
   time_t t;
   srand((unsigned)time(&t));

   for(i=0;i<30;i++){
		printf("%c\n", array[rand()%10]);
   }

   return 0;
}
