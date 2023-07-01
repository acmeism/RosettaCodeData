#include<stdlib.h>
#include<stdio.h>
#include<time.h>

typedef struct genome{
    char base;
    struct genome *next;
}genome;

typedef struct{
    char mutation;
    int position;
}genomeChange;

typedef struct{
    int adenineCount,thymineCount,cytosineCount,guanineCount;
}baseCounts;

genome *strand;
baseCounts baseData;
int genomeLength = 100, lineLength = 50;

int numDigits(int num){
    int len = 1;

    while(num>10){
        num /= 10;
        len++;
    }
    return len;
}

void generateStrand(){

    int baseChoice = rand()%4, i;
    genome *strandIterator, *newStrand;

    baseData.adenineCount = 0;
    baseData.thymineCount = 0;
    baseData.cytosineCount = 0;
    baseData.guanineCount = 0;

    strand = (genome*)malloc(sizeof(genome));
    strand->base = baseChoice==0?'A':(baseChoice==1?'T':(baseChoice==2?'C':'G'));
    baseChoice==0?baseData.adenineCount++:(baseChoice==1?baseData.thymineCount++:(baseChoice==2?baseData.cytosineCount++:baseData.guanineCount++));
    strand->next = NULL;

    strandIterator = strand;

    for(i=1;i<genomeLength;i++){
        baseChoice = rand()%4;

        newStrand = (genome*)malloc(sizeof(genome));
        newStrand->base = baseChoice==0?'A':(baseChoice==1?'T':(baseChoice==2?'C':'G'));
        baseChoice==0?baseData.adenineCount++:(baseChoice==1?baseData.thymineCount++:(baseChoice==2?baseData.cytosineCount++:baseData.guanineCount++));
        newStrand->next = NULL;

        strandIterator->next = newStrand;
        strandIterator = newStrand;
    }
}

genomeChange generateMutation(int swapWeight, int insertionWeight, int deletionWeight){
    int mutationChoice = rand()%(swapWeight + insertionWeight + deletionWeight);

    genomeChange mutationCommand;

    mutationCommand.mutation = mutationChoice<swapWeight?'S':((mutationChoice>=swapWeight && mutationChoice<swapWeight+insertionWeight)?'I':'D');
    mutationCommand.position = rand()%genomeLength;

    return mutationCommand;
}

void printGenome(){
    int rows, width = numDigits(genomeLength), len = 0,i,j;
	lineLength = (genomeLength<lineLength)?genomeLength:lineLength;
	
	rows = genomeLength/lineLength + (genomeLength%lineLength!=0);
	
    genome* strandIterator = strand;

    printf("\n\nGenome : \n--------\n");

    for(i=0;i<rows;i++){
        printf("\n%*d%3s",width,len,":");

        for(j=0;j<lineLength && strandIterator!=NULL;j++){
                printf("%c",strandIterator->base);
                strandIterator = strandIterator->next;
        }
        len += lineLength;
    }

    while(strandIterator!=NULL){
            printf("%c",strandIterator->base);
            strandIterator = strandIterator->next;
    }

    printf("\n\nBase Counts\n-----------");

    printf("\n%*c%3s%*d",width,'A',":",width,baseData.adenineCount);
    printf("\n%*c%3s%*d",width,'T',":",width,baseData.thymineCount);
    printf("\n%*c%3s%*d",width,'C',":",width,baseData.cytosineCount);
    printf("\n%*c%3s%*d",width,'G',":",width,baseData.guanineCount);
	
	printf("\n\nTotal:%*d",width,baseData.adenineCount + baseData.thymineCount + baseData.cytosineCount + baseData.guanineCount);

    printf("\n");
}

void mutateStrand(int numMutations, int swapWeight, int insertionWeight, int deletionWeight){
    int i,j,width,baseChoice;
    genomeChange newMutation;
    genome *strandIterator, *strandFollower, *newStrand;

    for(i=0;i<numMutations;i++){
        strandIterator = strand;
        strandFollower = strand;
        newMutation = generateMutation(swapWeight,insertionWeight,deletionWeight);
        width = numDigits(genomeLength);

        for(j=0;j<newMutation.position;j++){
            strandFollower = strandIterator;
            strandIterator = strandIterator->next;
        }

        if(newMutation.mutation=='S'){
            if(strandIterator->base=='A'){
                strandIterator->base='T';
                printf("\nSwapping A at position : %*d with T",width,newMutation.position);
            }
            else if(strandIterator->base=='A'){
                strandIterator->base='T';
                printf("\nSwapping A at position : %*d with T",width,newMutation.position);
            }
            else if(strandIterator->base=='C'){
                strandIterator->base='G';
                printf("\nSwapping C at position : %*d with G",width,newMutation.position);
            }
            else{
                strandIterator->base='C';
                printf("\nSwapping G at position : %*d with C",width,newMutation.position);
            }
        }

        else if(newMutation.mutation=='I'){
            baseChoice = rand()%4;

            newStrand = (genome*)malloc(sizeof(genome));
            newStrand->base = baseChoice==0?'A':(baseChoice==1?'T':(baseChoice==2?'C':'G'));
            printf("\nInserting %c at position : %*d",newStrand->base,width,newMutation.position);
            baseChoice==0?baseData.adenineCount++:(baseChoice==1?baseData.thymineCount++:(baseChoice==2?baseData.cytosineCount++:baseData.guanineCount++));
            newStrand->next = strandIterator;
            strandFollower->next = newStrand;
            genomeLength++;
        }

        else{
            strandFollower->next = strandIterator->next;
            strandIterator->next = NULL;
            printf("\nDeleting %c at position : %*d",strandIterator->base,width,newMutation.position);
            free(strandIterator);
            genomeLength--;
        }
    }
}

int main(int argc,char* argv[])
{
    int numMutations = 10, swapWeight = 10, insertWeight = 10, deleteWeight = 10;

    if(argc==1||argc>6){
                printf("Usage : %s <Genome Length> <Optional number of mutations> <Optional Swapping weight> <Optional Insertion weight> <Optional Deletion weight>\n",argv[0]);
                return 0;
    }

    switch(argc){
        case 2: genomeLength = atoi(argv[1]);
                break;
        case 3: genomeLength = atoi(argv[1]);
                numMutations = atoi(argv[2]);
                break;
        case 4: genomeLength = atoi(argv[1]);
                numMutations = atoi(argv[2]);
                swapWeight   = atoi(argv[3]);
                break;
        case 5: genomeLength = atoi(argv[1]);
                numMutations = atoi(argv[2]);
                swapWeight   = atoi(argv[3]);
                insertWeight = atoi(argv[4]);
                break;
        case 6: genomeLength = atoi(argv[1]);
                numMutations = atoi(argv[2]);
                swapWeight   = atoi(argv[3]);
                insertWeight = atoi(argv[4]);
                deleteWeight = atoi(argv[5]);
                break;
    };

    srand(time(NULL));
    generateStrand();
	
	printf("\nOriginal:");
    printGenome();
    mutateStrand(numMutations,swapWeight,insertWeight,deleteWeight);

	printf("\n\nMutated:");
	printGenome();

    return 0;
}
