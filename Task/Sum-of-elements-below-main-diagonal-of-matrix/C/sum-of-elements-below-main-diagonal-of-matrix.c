#include<stdlib.h>
#include<stdio.h>

typedef struct{
	int rows,cols;
	int** dataSet;
}matrix;

matrix readMatrix(char* dataFile){
	FILE* fp = fopen(dataFile,"r");
	matrix rosetta;
	int i,j;
	
	fscanf(fp,"%d%d",&rosetta.rows,&rosetta.cols);
	
	rosetta.dataSet = (int**)malloc(rosetta.rows*sizeof(int*));
	
	for(i=0;i<rosetta.rows;i++){
		rosetta.dataSet[i] = (int*)malloc(rosetta.cols*sizeof(int));
		for(j=0;j<rosetta.cols;j++)
			fscanf(fp,"%d",&rosetta.dataSet[i][j]);
	}
	
	fclose(fp);
	return rosetta;
}

void printMatrix(matrix rosetta){
	int i,j;
	
	for(i=0;i<rosetta.rows;i++){
		printf("\n");
		for(j=0;j<rosetta.cols;j++)
			printf("%3d",rosetta.dataSet[i][j]);
	}
}

int findSum(matrix rosetta){
	int i,j,sum = 0;
	
	for(i=1;i<rosetta.rows;i++){
		for(j=0;j<i;j++){
			sum += rosetta.dataSet[i][j];
		}
	}
	
	return sum;
}

int main(int argC,char* argV[])
{
	if(argC!=2)
		return printf("Usage : %s <filename>",argV[0]);
	
	matrix data = readMatrix(argV[1]);
	
	printf("\n\nMatrix is : \n\n");
	printMatrix(data);
	
	printf("\n\nSum below main diagonal : %d",findSum(data));
	
	return 0;
}
