#include <stdio.h>

int main(int argc, char *argv[])
{
        if(argc == 99)
                return 99;
        if(argv[0] != NULL){
                argv[0] = NULL;
                argc = 0;
        }
        argc = main(argc + 1, argv);
        printf("%d bottle%c of beer on the wall\n", argc, argc == 1?'\0': 's');
        printf("%d bottle%c of beer\n", argc, argc == 1?'\0': 's');
        printf("Take one down, pass it around\n");
        printf("%d bottle%c of beer on the wall\n\n", argc - 1, (argc - 1) == 1?'\0': 's');
        return argc - 1;
}
