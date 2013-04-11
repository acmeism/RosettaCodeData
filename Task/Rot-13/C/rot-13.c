#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>

#define MAXLINE 1024

char *rot13(char *s)
{
        char *p=s;
        int upper;

        while(*p) {
                upper=toupper(*p);
                if(upper>='A' && upper<='M') *p+=13;
                else if(upper>='N' && upper<='Z') *p-=13;
                ++p;
        }
        return s;
}

void rot13file(FILE *fp)
{
        static char line[MAXLINE];
        while(fgets(line, MAXLINE, fp)>0) fputs(rot13(line), stdout);
}

int main(int argc, char *argv[])
{
        int n;
        FILE *fp;

        if(argc>1) {
                for(n=1; n<argc; ++n) {
                        if(!(fp=fopen(argv[n], "r"))) {
                                fprintf(stderr, "ERROR: Couldn\'t read %s\n", argv[n]);
                                exit(EXIT_FAILURE);
                        }
                        rot13file(fp);
                        fclose(fp);
                }
        } else rot13file(stdin);

        return EXIT_SUCCESS;
}
