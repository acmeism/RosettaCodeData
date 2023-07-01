#include<limits.h>
#include<stdio.h>

int fusc(int n){
        if(n==0||n==1)
                return n;
        else if(n%2==0)
                return fusc(n/2);
        else
                return fusc((n-1)/2) + fusc((n+1)/2);
}

int numLen(int n){
        int sum = 1;

        while(n>9){
                n = n/10;
                sum++;
        }

        return sum;
}

void printLargeFuscs(int limit){
        int i,f,len,maxLen = 1;

        printf("\n\nPrinting all largest Fusc numbers upto %d \nIndex-------Value",limit);

        for(i=0;i<=limit;i++){
                f = fusc(i);
                len = numLen(f);

                if(len>maxLen){
                        maxLen = len;
                        printf("\n%5d%12d",i,f);
                }
        }
}


int main()
{
        int i;

        printf("Index-------Value");
        for(i=0;i<61;i++)
                printf("\n%5d%12d",i,fusc(i));
        printLargeFuscs(INT_MAX);
        return 0;
}
