#include<string.h>
#include<stdlib.h>
#include<stdio.h>

#define MAX 3

int main()
{
  char values[MAX][100],tempStr[100];
  int i,j,isString=0;
  double val[MAX],temp;

  for(i=0;i<MAX;i++){
    printf("Enter %d%s value : ",i+1,(i==0)?"st":((i==1)?"nd":"rd"));
    fgets(values[i],100,stdin);

    for(j=0;values[i][j]!=00;j++){
      if(((values[i][j]<'0' || values[i][j]>'9') && (values[i][j]!='.' ||values[i][j]!='-'||values[i][j]!='+'))
      ||((values[i][j]=='.' ||values[i][j]=='-'||values[i][j]=='+')&&(values[i][j+1]<'0' || values[i][j+1]>'9')))
        isString = 1;
    }
  }

  if(isString==0){
    for(i=0;i<MAX;i++)
      val[i] = atof(values[i]);
  }

  for(i=0;i<MAX-1;i++){
    for(j=i+1;j<MAX;j++){
      if(isString==0 && val[i]>val[j]){
        temp = val[j];
        val[j] = val[i];
        val[i] = temp;
      }

      else if(values[i][0]>values[j][0]){
        strcpy(tempStr,values[j]);
        strcpy(values[j],values[i]);
        strcpy(values[i],tempStr);
      }
    }
  }

  for(i=0;i<MAX;i++)
    isString==1?printf("%c = %s",'X'+i,values[i]):printf("%c = %lf",'X'+i,val[i]);

  return 0;
}
