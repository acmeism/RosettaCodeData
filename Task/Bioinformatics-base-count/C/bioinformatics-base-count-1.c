#include<string.h>
#include<stdlib.h>
#include<stdio.h>

typedef struct genome{
    char* strand;
    int length;
    struct genome* next;
}genome;

genome* genomeData;
int totalLength = 0, Adenine = 0, Cytosine = 0, Guanine = 0, Thymine = 0;

int numDigits(int num){
    int len = 1;

    while(num>10){
        num = num/10;
        len++;
    }

    return len;
}

void buildGenome(char str[100]){
    int len = strlen(str),i;
    genome *genomeIterator, *newGenome;

    totalLength += len;

    for(i=0;i<len;i++){
        switch(str[i]){
            case 'A': Adenine++;
                break;
            case 'T': Thymine++;
                break;
            case 'C': Cytosine++;
                break;
            case 'G': Guanine++;
                break;
        };
    }

    if(genomeData==NULL){
        genomeData = (genome*)malloc(sizeof(genome));

        genomeData->strand = (char*)malloc(len*sizeof(char));
        strcpy(genomeData->strand,str);
        genomeData->length = len;

        genomeData->next = NULL;
    }

    else{
        genomeIterator = genomeData;

        while(genomeIterator->next!=NULL)
            genomeIterator = genomeIterator->next;

        newGenome = (genome*)malloc(sizeof(genome));

        newGenome->strand = (char*)malloc(len*sizeof(char));
        strcpy(newGenome->strand,str);
        newGenome->length = len;

        newGenome->next = NULL;
        genomeIterator->next = newGenome;
    }
}

void printGenome(){
    genome* genomeIterator = genomeData;

    int width = numDigits(totalLength), len = 0;

    printf("Sequence:\n");

    while(genomeIterator!=NULL){
        printf("\n%*d%3s%3s",width+1,len,":",genomeIterator->strand);
        len += genomeIterator->length;

        genomeIterator = genomeIterator->next;
    }

    printf("\n\nBase Count\n----------\n\n");

    printf("%3c%3s%*d\n",'A',":",width+1,Adenine);
    printf("%3c%3s%*d\n",'T',":",width+1,Thymine);
    printf("%3c%3s%*d\n",'C',":",width+1,Cytosine);
    printf("%3c%3s%*d\n",'G',":",width+1,Guanine);
    printf("\n%3s%*d\n","Total:",width+1,Adenine + Thymine + Cytosine + Guanine);

    free(genomeData);
}

int main(int argc,char** argv)
{
    char str[100];
    int counter = 0, len;

    if(argc!=2){
        printf("Usage : %s <Gene file name>\n",argv[0]);
        return 0;
    }

    FILE *fp = fopen(argv[1],"r");

    while(fscanf(fp,"%s",str)!=EOF)
        buildGenome(str);
    fclose(fp);

    printGenome();

    return 0;
}
