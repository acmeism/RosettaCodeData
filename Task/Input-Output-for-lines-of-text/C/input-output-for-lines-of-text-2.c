// Programa IO.C
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

int check_number(const char *s){
  const char*t=s;
  while(*t!='\n'){
    if( !isdigit(*t) ) return 0;
    ++t;
  }
  return 1;
}
int main( int argc, char *argv[] )
{
   char s[100],r[10];
   int n=0;
   FILE *fp;

   fgets(s,100,stdin);  // input trough stdin.

   if( (fp = fopen("temporal.txt","r"))!=NULL){
      fgets(r,10,fp);
      n=atoi(r);
      if(n>0){
         --n;
         fclose(fp);
         fp=fopen("temporal.txt","w");
         sprintf(r,"%d",n);
         fputs(r,fp);
         fclose(fp);
         printf("%s\n",s);
      }else{
         fclose(fp);
         remove("temporal.txt");
         perror("I need a number of the lines here!\n");
      }
   }else{
      if(check_number((const char*)s)){
         fp=fopen("temporal.txt","w");
         fputs(s,fp);
         fclose(fp);
      }else{
         perror("I need a number of the lines here!\n");
      }
   }
   return 0;
}
