#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#define MAX_SIZE 100

int move_to_front(char *str,char c)
{
    char *q,*p;
    int shift=0;
    p=(char *)malloc(strlen(str)+1);
    strcpy(p,str);
    q=strchr(p,c); //returns pointer to location of char c in string str
    shift=q-p;      // no of characters from 0 to position of c in str
    strncpy(str+1,p,shift);
    str[0]=c;
    free(p);
  //  printf("\n%s\n",str);
    return shift;
}

void decode(int* pass,int size,char *sym)
{
    int i,index;
    char c;
    char table[]="abcdefghijklmnopqrstuvwxyz";
    for(i=0;i<size;i++)
    {
        c=table[pass[i]];
        index=move_to_front(table,c);
        if(pass[i]!=index) printf("there is an error");
        sym[i]=c;
    }
    sym[size]='\0';
}

void encode(char *sym,int size,int *pass)
{
    int i=0;
    char c;
    char table[]="abcdefghijklmnopqrstuvwxyz";
    for(i=0;i<size;i++)
    {
        c=sym[i];
        pass[i]=move_to_front(table,c);
    }
}

int check(char *sym,int size,int *pass)
{
    int *pass2=malloc(sizeof(int)*size);
    char *sym2=malloc(sizeof(char)*size);
    int i,val=1;

    encode(sym,size,pass2);
    i=0;
    while(i<size && pass[i]==pass2[i])i++;
    if(i!=size)val=0;

    decode(pass,size,sym2);
    if(strcmp(sym,sym2)!=0)val=0;

    free(sym2);
    free(pass2);

    return val;
}

int main()
{
    char sym[3][MAX_SIZE]={"broood","bananaaa","hiphophiphop"};
    int pass[MAX_SIZE]={0};
    int i,len,j;
    for(i=0;i<3;i++)
    {
        len=strlen(sym[i]);
        encode(sym[i],len,pass);
        printf("%s : [",sym[i]);
        for(j=0;j<len;j++)
            printf("%d ",pass[j]);
        printf("]\n");
        if(check(sym[i],len,pass))
            printf("Correct :)\n");
        else
            printf("Incorrect :(\n");
    }
    return 0;
}
