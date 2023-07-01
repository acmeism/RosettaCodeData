#include<string.h>
#include<stdlib.h>
#include<stdio.h>

void cartesianProduct(int** sets, int* setLengths, int* currentSet, int numSets, int times){
	int i,j;
	
	if(times==numSets){
		printf("(");
		for(i=0;i<times;i++){
			printf("%d,",currentSet[i]);
		}
		printf("\b),");
	}
	else{
		for(j=0;j<setLengths[times];j++){
			currentSet[times] = sets[times][j];
			cartesianProduct(sets,setLengths,currentSet,numSets,times+1);
		}
	}
}

void printSets(int** sets, int* setLengths, int numSets){
	int i,j;
	
	printf("\nNumber of sets : %d",numSets);
	
	for(i=0;i<numSets+1;i++){
		printf("\nSet %d : ",i+1);
		for(j=0;j<setLengths[i];j++){
			printf(" %d ",sets[i][j]);
		}
	}
}

void processInputString(char* str){
	int **sets, *currentSet, *setLengths, setLength, numSets = 0, i,j,k,l,start,counter=0;
	char *token,*holder,*holderToken;
	
	for(i=0;str[i]!=00;i++)
		if(str[i]=='x')
			numSets++;
		
	if(numSets==0){
			printf("\n%s",str);
			return;
	}
		
	currentSet = (int*)calloc(sizeof(int),numSets + 1);
	
	setLengths = (int*)calloc(sizeof(int),numSets + 1);
	
	sets = (int**)malloc((numSets + 1)*sizeof(int*));
	
	token = strtok(str,"x");
	
	while(token!=NULL){
		holder = (char*)malloc(strlen(token)*sizeof(char));
		
		j = 0;
		
		for(i=0;token[i]!=00;i++){
			if(token[i]>='0' && token[i]<='9')
				holder[j++] = token[i];
			else if(token[i]==',')
				holder[j++] = ' ';
		}
		holder[j] = 00;
		
		setLength = 0;
		
		for(i=0;holder[i]!=00;i++)
			if(holder[i]==' ')
				setLength++;
			
		if(setLength==0 && strlen(holder)==0){
			printf("\n{}");
			return;
		}
		
		setLengths[counter] = setLength+1;
		
		sets[counter] = (int*)malloc((1+setLength)*sizeof(int));
		
		k = 0;
		
		start = 0;
		
		for(l=0;holder[l]!=00;l++){
			if(holder[l+1]==' '||holder[l+1]==00){
				holderToken = (char*)malloc((l+1-start)*sizeof(char));
				strncpy(holderToken,holder + start,l+1-start);
				sets[counter][k++] = atoi(holderToken);
				start = l+2;
			}
		}
		
		counter++;
		token = strtok(NULL,"x");
	}
	
	printf("\n{");
	cartesianProduct(sets,setLengths,currentSet,numSets + 1,0);
	printf("\b}");
	
}

int main(int argC,char* argV[])
{
	if(argC!=2)
		printf("Usage : %s <Set product expression enclosed in double quotes>",argV[0]);
	else
		processInputString(argV[1]);
	
	return 0;
}
