#include<string.h>
#include<stdio.h>

int main(int argc,char** argv)
{
    int i,len;
    char reference;

    if(argc>2){
        printf("Usage : %s <Test String>\n",argv[0]);
        return 0;
    }

    if(argc==1||strlen(argv[1])==1){
        printf("Input string : \"%s\"\nLength : %d\nAll characters are identical.\n",argc==1?"":argv[1],argc==1?0:(int)strlen(argv[1]));
        return 0;
    }

    reference = argv[1][0];
    len = strlen(argv[1]);

    for(i=1;i<len;i++){
        if(argv[1][i]!=reference){
            printf("Input string : \"%s\"\nLength : %d\nFirst different character : \"%c\"(0x%x) at position : %d\n",argv[1],len,argv[1][i],argv[1][i],i+1);
            return 0;
        }
    }

    printf("Input string : \"%s\"\nLength : %d\nAll characters are identical.\n",argv[1],len);

    return 0;

}
