#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main()
{
    char str[100]="my String";
    char *cstr="Changed ";
    char *dup;
    sprintf(str,"%s%s",cstr,(dup=strdup(str)));
    free(dup);
    printf("%s\n",str);
    return 0;
}
