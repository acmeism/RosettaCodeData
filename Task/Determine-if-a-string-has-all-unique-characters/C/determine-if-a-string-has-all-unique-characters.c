#include<stdbool.h>
#include<string.h>
#include<stdlib.h>
#include<stdio.h>

typedef struct positionList{
    int position;
    struct positionList *next;
}positionList;

typedef struct letterList{
    char letter;
    int repititions;
    positionList* positions;
    struct letterList *next;
}letterList;

letterList* letterSet;
bool duplicatesFound = false;

void checkAndUpdateLetterList(char c,int pos){
    bool letterOccurs = false;
    letterList *letterIterator,*newLetter;
    positionList *positionIterator,*newPosition;

    if(letterSet==NULL){
        letterSet = (letterList*)malloc(sizeof(letterList));
        letterSet->letter = c;
        letterSet->repititions = 0;

        letterSet->positions = (positionList*)malloc(sizeof(positionList));
        letterSet->positions->position = pos;
        letterSet->positions->next = NULL;

        letterSet->next = NULL;
    }

    else{
        letterIterator = letterSet;

        while(letterIterator!=NULL){
            if(letterIterator->letter==c){
                letterOccurs = true;
                duplicatesFound = true;

                letterIterator->repititions++;
                positionIterator = letterIterator->positions;

                while(positionIterator->next!=NULL)
                    positionIterator = positionIterator->next;

                newPosition = (positionList*)malloc(sizeof(positionList));
                newPosition->position = pos;
                newPosition->next = NULL;

                positionIterator->next = newPosition;
            }
            if(letterOccurs==false && letterIterator->next==NULL)
                break;
            else
                letterIterator = letterIterator->next;
        }

        if(letterOccurs==false){
            newLetter = (letterList*)malloc(sizeof(letterList));
            newLetter->letter = c;

            newLetter->repititions = 0;

            newLetter->positions = (positionList*)malloc(sizeof(positionList));
            newLetter->positions->position = pos;
            newLetter->positions->next = NULL;

            newLetter->next = NULL;

            letterIterator->next = newLetter;
        }
    }
}

void printLetterList(){
    positionList* positionIterator;
    letterList* letterIterator = letterSet;

    while(letterIterator!=NULL){
        if(letterIterator->repititions>0){
            printf("\n'%c' (0x%x) at positions :",letterIterator->letter,letterIterator->letter);

            positionIterator = letterIterator->positions;

            while(positionIterator!=NULL){
                printf("%3d",positionIterator->position + 1);
                positionIterator = positionIterator->next;
            }
        }

        letterIterator = letterIterator->next;
    }
    printf("\n");
}

int main(int argc,char** argv)
{
    int i,len;

    if(argc>2){
        printf("Usage : %s <Test string>\n",argv[0]);
        return 0;
    }

    if(argc==1||strlen(argv[1])==1){
        printf("\"%s\" - Length %d - Contains only unique characters.\n",argc==1?"":argv[1],argc==1?0:1);
        return 0;
    }

    len = strlen(argv[1]);

    for(i=0;i<len;i++){
        checkAndUpdateLetterList(argv[1][i],i);
    }

    printf("\"%s\" - Length %d - %s",argv[1],len,duplicatesFound==false?"Contains only unique characters.\n":"Contains the following duplicate characters :");

    if(duplicatesFound==true)
        printLetterList();

    return 0;
}
