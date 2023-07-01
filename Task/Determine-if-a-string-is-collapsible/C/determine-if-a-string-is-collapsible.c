#include<string.h>
#include<stdlib.h>
#include<stdio.h>

#define COLLAPSE 0
#define SQUEEZE 1

typedef struct charList{
    char c;
    struct charList *next;
} charList;

/*
Implementing strcmpi, the case insensitive string comparator, as it is not part of the C Standard Library.

Comment this out if testing on a compiler where it is already defined.
*/

int strcmpi(char* str1,char* str2){
    int len1 = strlen(str1), len2 = strlen(str2), i;

    if(len1!=len2){
        return 1;
    }

    else{
        for(i=0;i<len1;i++){
            if((str1[i]>='A'&&str1[i]<='Z')&&(str2[i]>='a'&&str2[i]<='z')&&(str2[i]-65!=str1[i]))
                return 1;
            else if((str2[i]>='A'&&str2[i]<='Z')&&(str1[i]>='a'&&str1[i]<='z')&&(str1[i]-65!=str2[i]))
                return 1;
            else if(str1[i]!=str2[i])
                return 1;
        }
    }

    return 0;
}

charList *strToCharList(char* str){
    int len = strlen(str),i;

    charList *list, *iterator, *nextChar;

    list = (charList*)malloc(sizeof(charList));
    list->c = str[0];
    list->next = NULL;

    iterator = list;

    for(i=1;i<len;i++){
        nextChar = (charList*)malloc(sizeof(charList));
        nextChar->c = str[i];
        nextChar->next = NULL;

        iterator->next = nextChar;
        iterator = nextChar;
    }

    return list;
}

char* charListToString(charList* list){
    charList* iterator = list;
    int count = 0,i;
    char* str;

    while(iterator!=NULL){
        count++;
        iterator = iterator->next;
    }

    str = (char*)malloc((count+1)*sizeof(char));
    iterator = list;

    for(i=0;i<count;i++){
        str[i] = iterator->c;
        iterator = iterator->next;
    }

    free(list);
    str[i] = '\0';

    return str;
}

char* processString(char str[100],int operation, char squeezeChar){
    charList *strList = strToCharList(str),*iterator = strList, *scout;

    if(operation==SQUEEZE){
        while(iterator!=NULL){
            if(iterator->c==squeezeChar){
                scout = iterator->next;

                while(scout!=NULL && scout->c==squeezeChar){
                        iterator->next = scout->next;
                        scout->next = NULL;
                        free(scout);
                        scout = iterator->next;
                }
            }
            iterator = iterator->next;
        }
    }

    else{
        while(iterator!=NULL && iterator->next!=NULL){
            if(iterator->c == (iterator->next)->c){
                scout = iterator->next;
                squeezeChar = iterator->c;

                while(scout!=NULL && scout->c==squeezeChar){
                        iterator->next = scout->next;
                        scout->next = NULL;
                        free(scout);
                        scout = iterator->next;
                }
            }
            iterator = iterator->next;
        }
    }

    return charListToString(strList);
}

void printResults(char originalString[100], char finalString[100], int operation, char squeezeChar){
    if(operation==SQUEEZE){
        printf("Specified Operation : SQUEEZE\nTarget Character : %c",squeezeChar);
    }

    else
        printf("Specified Operation : COLLAPSE");

    printf("\nOriginal %c%c%c%s%c%c%c\nLength : %d",174,174,174,originalString,175,175,175,(int)strlen(originalString));
    printf("\nFinal    %c%c%c%s%c%c%c\nLength : %d\n",174,174,174,finalString,175,175,175,(int)strlen(finalString));
}

int main(int argc, char** argv){
    int operation;
    char squeezeChar;

    if(argc<3||argc>4){
        printf("Usage : %s <SQUEEZE|COLLAPSE> <String to be processed> <Character to be squeezed, if operation is SQUEEZE>\n",argv[0]);
        return 0;
    }

    if(strcmpi(argv[1],"SQUEEZE")==0 && argc!=4){
        scanf("Please enter characted to be squeezed : %c",&squeezeChar);
        operation = SQUEEZE;
    }

    else if(argc==4){
        operation = SQUEEZE;
        squeezeChar = argv[3][0];
    }

    else if(strcmpi(argv[1],"COLLAPSE")==0){
        operation = COLLAPSE;
    }

    if(strlen(argv[2])<2){
        printResults(argv[2],argv[2],operation,squeezeChar);
    }

    else{
        printResults(argv[2],processString(argv[2],operation,squeezeChar),operation,squeezeChar);
    }

    return 0;
}
