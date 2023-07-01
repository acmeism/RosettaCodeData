#include<stdlib.h>
#include<string.h>
#include<stdio.h>

#define MAX_LEN 1000

typedef struct{
	float* values;
	int size;
}vector;

vector extractVector(char* str){
	vector coeff;
	int i=0,count = 1;
	char* token;
	
	while(str[i]!=00){
		if(str[i++]==' ')
			count++;
	}
	
	coeff.values = (float*)malloc(count*sizeof(float));
	coeff.size = count;
	
	token = strtok(str," ");
	
	i = 0;
	
	while(token!=NULL){
		coeff.values[i++] = atof(token);
		token = strtok(NULL," ");
	}
	
	return coeff;
}

vector processSignalFile(char* fileName){
	int i,j;
	float sum;
	char str[MAX_LEN];
	vector coeff1,coeff2,signal,filteredSignal;
	
	FILE* fp = fopen(fileName,"r");
	
	fgets(str,MAX_LEN,fp);
	coeff1 = extractVector(str);
	
	fgets(str,MAX_LEN,fp);
	coeff2 = extractVector(str);
	
	fgets(str,MAX_LEN,fp);
	signal = extractVector(str);

        fclose(fp);
	
	filteredSignal.values = (float*)calloc(signal.size,sizeof(float));
	filteredSignal.size = signal.size;
	
	for(i=0;i<signal.size;i++){
		sum = 0;
		
		for(j=0;j<coeff2.size;j++){
			if(i-j>=0)
				sum += coeff2.values[j]*signal.values[i-j];
		}
		
		for(j=0;j<coeff1.size;j++){
			if(i-j>=0)
				sum -= coeff1.values[j]*filteredSignal.values[i-j];
		}
		
		sum /= coeff1.values[0];
		filteredSignal.values[i] = sum;
	}
	
	return filteredSignal;
}

void printVector(vector v, char* outputFile){
	int i;
	
	if(outputFile==NULL){
		printf("[");
		for(i=0;i<v.size;i++)
			printf("%.12f, ",v.values[i]);
		printf("\b\b]");
	}
	
	else{
		FILE* fp = fopen(outputFile,"w");
		for(i=0;i<v.size-1;i++)
			fprintf(fp,"%.12f, ",v.values[i]);
		fprintf(fp,"%.12f",v.values[i]);
		fclose(fp);
	}
	
}

int main(int argC,char* argV[])
{
	char *str;
	if(argC<2||argC>3)
		printf("Usage : %s <name of signal data file and optional output file.>",argV[0]);
	else{
		if(argC!=2){
			str = (char*)malloc((strlen(argV[2]) + strlen(str) + 1)*sizeof(char));
			strcpy(str,"written to ");
		}
		printf("Filtered signal %s",(argC==2)?"is:\n":strcat(str,argV[2]));
		printVector(processSignalFile(argV[1]),argV[2]);
	}
	return 0;
}
