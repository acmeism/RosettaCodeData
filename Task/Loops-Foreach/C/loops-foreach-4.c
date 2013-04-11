#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc,char* argv[]){
#define foreach( idxtype , idxpvar , col , colsiz ) idxtype* idxpvar; for( idxpvar=col ; idxpvar < (col+(colsiz)) ; idxpvar++)
#define arraylen( ary ) ( sizeof(ary)/sizeof(ary[0]) )
char* c1="collection";
int c2[]={ 3 , 1 , 4 , 1, 5, 9 };
double* c3;
int c3len=4;
c3=(double*)calloc(c3len,sizeof(double));
c3[0]=1.2;c3[1]=3.4;c3[2]=5.6;c3[3]=7.8;
foreach( char,p1   , c1, strlen(c1) ) {
 printf("loop 1 : %c\n",*p1);
}
foreach( int,p2    , c2, arraylen(c2) ){
 printf("loop 2 : %d\n",*p2);
}
foreach( double,p3 , c3, c3len ){
 printf("loop 3 : %3.1lf\n",*p3);
}
exit(0);
return(0);
}
