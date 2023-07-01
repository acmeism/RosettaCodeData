#include<stdio.h>

void generateGaps(unsigned long long int start,int count){

    int counter = 0;
    unsigned long long int i = start;
    char str[100];

    printf("\nFirst %d Gapful numbers >= %llu :\n",count,start);

    while(counter<count){
        sprintf(str,"%llu",i);
        if((i%(10*(str[0]-'0') + i%10))==0L){
            printf("\n%3d : %llu",counter+1,i);
            counter++;
        }
        i++;
    }
}

int main()
{
    unsigned long long int i = 100;
    int count = 0;
    char str[21];

    generateGaps(100,30);
    printf("\n");
    generateGaps(1000000,15);
    printf("\n");
    generateGaps(1000000000,15);
    printf("\n");

    return 0;
}
