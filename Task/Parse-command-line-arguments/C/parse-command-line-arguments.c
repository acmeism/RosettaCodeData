#include <stdio.h>
int main(int argc, char **argv){
    int i;
    const char *commands[]={"-c", "-p", "-t", "-d", "-a", NULL};
    enum {CREATE,PRINT,TITLE,DATE,AUTH};
    if (argc<2) {
usage:   printf ("Usage: %s [commands]\n"
            "-c  Create new entry.\n"
            "-p  Print the latest entry.\n"
            "-t  Sort by title.\n"
            "-d  Sort by date.\n"
            "-a  Sort by author.\n",argv[0]);
        return 0;
    }
    for (i=0;commands[i]&&strcmp(argv[1],commands[i]);i++);
    switch (i) {
    case CREATE:
...
    break;
    case PRINT:
...
    break;
...
...
    default:
    printf ("Unknown command..." ...);
    goto usage;
    }
    return 0;
}
