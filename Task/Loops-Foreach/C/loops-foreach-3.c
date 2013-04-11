#include <stdio.h>
#include <stdlib.h>
int main(int argc,char* argv[]){
/* foreach macro viewing an array of int values as a collection of int values */
#define foreach( intpvar , intary ) int* intpvar; for( intpvar=intary; intpvar < (intary+(sizeof(intary)/sizeof(intary[0]))) ; intpvar++)
int a1[]={ 1 , 1 , 2 , 3 , 5 , 8 };
int a2[]={ 3 , 1 , 4 , 1, 5, 9 };
foreach( p1 , a1 ) {
 printf("loop 1 %d\n",*p1);
}
foreach( p2 , a2 ){
 printf("loop 2 %d\n",*p2);
}
exit(0);
return(0);
}
