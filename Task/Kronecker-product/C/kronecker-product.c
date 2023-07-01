#include<stdlib.h>
#include<stdio.h>

int main(){
	
	char input[100],output[100];
	int i,j,k,l,rowA,colA,rowB,colB,rowC,colC,startRow,startCol;
	double **matrixA,**matrixB,**matrixC;
	
	printf("Enter full path of input file : ");
	fscanf(stdin,"%s",input);
	
	printf("Enter full path of output file : ");
	fscanf(stdin,"%s",output);
	
	FILE* inputFile = fopen(input,"r");
	
	fscanf(inputFile,"%d%d",&rowA,&colA);
	
	matrixA = (double**)malloc(rowA * sizeof(double*));
	
	for(i=0;i<rowA;i++){
		matrixA[i] = (double*)malloc(colA*sizeof(double));
		for(j=0;j<colA;j++){
			fscanf(inputFile,"%lf",&matrixA[i][j]);
		}
	}
	
	fscanf(inputFile,"%d%d",&rowB,&colB);
	
	matrixB = (double**)malloc(rowB * sizeof(double*));
	
	for(i=0;i<rowB;i++){
		matrixB[i] = (double*)malloc(colB*sizeof(double));
		for(j=0;j<colB;j++){
			fscanf(inputFile,"%lf",&matrixB[i][j]);
		}
	}
	
	fclose(inputFile);
	
	rowC = rowA*rowB;
	colC = colA*colB;
	
	matrixC = (double**)malloc(rowC*sizeof(double*));
	
	for(i=0;i<rowA*rowB;i++){
		matrixC[i] = (double*)malloc(colA*colB*sizeof(double));
	}
	
	for(i=0;i<rowA;i++){
		for(j=0;j<colA;j++){
			startRow = i*rowB;
			startCol = j*colB;
			for(k=0;k<rowB;k++){
				for(l=0;l<colB;l++){
					matrixC[startRow+k][startCol+l] = matrixA[i][j]*matrixB[k][l];
				}
			}
		}
	}

	FILE* outputFile = fopen(output,"w");
	
	for(i=0;i<rowC;i++){
		for(j=0;j<colC;j++){
			fprintf(outputFile,"%lf\t",matrixC[i][j]);
		}
		fprintf(outputFile,"\n");
	}
	
	fclose(outputFile);
	
	printf("\n\n\nKronecker product of the two matrices written to %s.",output);
}
