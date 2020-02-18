#include<stdlib.h>
#include<stdio.h>

typedef struct{
        int x;
        int (*funcPtr)(int);
}functionPair;

int factorial(int num){
        if(num==0||num==1)
                return 1;
        else
                return num*factorial(num-1);
}

int main(int argc,char** argv)
{
        functionPair response;

        if(argc!=2)
                return printf("Usage : %s <non negative integer>",argv[0]);
        else{
                response = (functionPair){.x = atoi(argv[1]),.funcPtr=&factorial};
                printf("\nFactorial of %d is %d\n",response.x,response.funcPtr(response.x));
        }
        return 0;
}
