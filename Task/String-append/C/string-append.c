#include<stdio.h>
#include<string.h>

int main()
{
    char str[24]="Good Morning";
    char *cstr=" to all";
    char *cstr2=" !!!";
    int x=0;
    //failure when space allocated to str is insufficient.

    if(sizeof(str)>strlen(str)+strlen(cstr)+strlen(cstr2))
            {
                /* 1st method*/
                strcat(str,cstr);

                /*2nd method*/
                x=strlen(str);
                sprintf(&str[x],"%s",cstr2);

                printf("%s\n",str);

            }
    return 0;
}
