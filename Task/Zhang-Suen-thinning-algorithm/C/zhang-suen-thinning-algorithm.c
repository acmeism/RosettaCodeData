/*Abhishek Ghosh, 24th September 2017*/

#include<stdlib.h>
#include<stdio.h>

char** imageMatrix;

char blankPixel,imagePixel;

typedef struct{
	int row,col;
}pixel;

int getBlackNeighbours(int row,int col){
	
	int i,j,sum = 0;
	
	for(i=-1;i<=1;i++){
		for(j=-1;j<=1;j++){
			if(i!=0 && j!=0)
				sum+= (imageMatrix[row+i][col+i]==imagePixel);
		}
	}
	
	return sum;
}

int getBWTransitions(int row,int col){
	return 	((imageMatrix[row-1][col]==blankPixel && imageMatrix[row-1][col+1]==imagePixel)
			+(imageMatrix[row-1][col+1]==blankPixel && imageMatrix[row][col+1]==imagePixel)
			+(imageMatrix[row][col+1]==blankPixel && imageMatrix[row+1][col+1]==imagePixel)
			+(imageMatrix[row+1][col+1]==blankPixel && imageMatrix[row+1][col]==imagePixel)
			+(imageMatrix[row+1][col]==blankPixel && imageMatrix[row+1][col-1]==imagePixel)
			+(imageMatrix[row+1][col-1]==blankPixel && imageMatrix[row][col-1]==imagePixel)
			+(imageMatrix[row][col-1]==blankPixel && imageMatrix[row-1][col-1]==imagePixel)
			+(imageMatrix[row-1][col-1]==blankPixel && imageMatrix[row-1][col]==imagePixel));
}

int zhangSuenTest1(int row,int col){
	int neighbours = getBlackNeighbours(row,col);
	
	return ((neighbours>=2 && neighbours<=6)
		&& (getBWTransitions(row,col)==1)
		&& (imageMatrix[row-1][col]==blankPixel||imageMatrix[row][col+1]==blankPixel||imageMatrix[row+1][col]==blankPixel)
		&& (imageMatrix[row][col+1]==blankPixel||imageMatrix[row+1][col]==blankPixel||imageMatrix[row][col-1]==blankPixel));
}

int zhangSuenTest2(int row,int col){
	int neighbours = getBlackNeighbours(row,col);
	
	return ((neighbours>=2 && neighbours<=6)
		&& (getBWTransitions(row,col)==1)
		&& (imageMatrix[row-1][col]==blankPixel||imageMatrix[row][col+1]==blankPixel||imageMatrix[row][col-1]==blankPixel)
		&& (imageMatrix[row-1][col]==blankPixel||imageMatrix[row+1][col]==blankPixel||imageMatrix[row][col+1]==blankPixel));
}

void zhangSuen(char* inputFile, char* outputFile){
	
	int startRow = 1,startCol = 1,endRow,endCol,i,j,count,rows,cols,processed;
	
	pixel* markers;
	
	FILE* inputP = fopen(inputFile,"r");
	
	fscanf(inputP,"%d%d",&rows,&cols);
	
	fscanf(inputP,"%d%d",&blankPixel,&imagePixel);
	
	blankPixel<=9?blankPixel+='0':blankPixel;
	imagePixel<=9?imagePixel+='0':imagePixel;
	
	printf("\nPrinting original image :\n");
	
	imageMatrix = (char**)malloc(rows*sizeof(char*));
	
	for(i=0;i<rows;i++){
		imageMatrix[i] = (char*)malloc((cols+1)*sizeof(char));
		fscanf(inputP,"%s\n",imageMatrix[i]);
		printf("\n%s",imageMatrix[i]);
		
	}

	fclose(inputP);
	
	endRow = rows-2;
	endCol = cols-2;
	do{
		markers = (pixel*)malloc((endRow-startRow+1)*(endCol-startCol+1)*sizeof(pixel));
		count = 0;
		
		for(i=startRow;i<=endRow;i++){
			for(j=startCol;j<=endCol;j++){
				if(imageMatrix[i][j]==imagePixel && zhangSuenTest1(i,j)==1){
					markers[count].row = i;
					markers[count].col = j;
					count++;
				}
			}
		}
		
		processed = (count>0);
		
		for(i=0;i<count;i++){
			imageMatrix[markers[i].row][markers[i].col] = blankPixel;
		}
		
		free(markers);
		markers = (pixel*)malloc((endRow-startRow+1)*(endCol-startCol+1)*sizeof(pixel));
		count = 0;
		
		for(i=startRow;i<=endRow;i++){
			for(j=startCol;j<=endCol;j++){
				if(imageMatrix[i][j]==imagePixel && zhangSuenTest2(i,j)==1){
					markers[count].row = i;
					markers[count].col = j;
					count++;
				}
			}
		}
		
		if(processed==0)
			processed = (count>0);
		
		for(i=0;i<count;i++){
			imageMatrix[markers[i].row][markers[i].col] = blankPixel;
		}
		
		free(markers);
	}while(processed==1);
	
	FILE* outputP = fopen(outputFile,"w");
	
	printf("\n\n\nPrinting image after applying Zhang Suen Thinning Algorithm : \n\n\n");
	
	for(i=0;i<rows;i++){
		for(j=0;j<cols;j++){
			printf("%c",imageMatrix[i][j]);
			fprintf(outputP,"%c",imageMatrix[i][j]);
		}
		printf("\n");
		fprintf(outputP,"\n");
	}
	
	fclose(outputP);
	
	printf("\nImage also written to : %s",outputFile);
}

int main()
{
	char inputFile[100],outputFile[100];
	
	printf("Enter full path of input image file : ");
	scanf("%s",inputFile);
	
	printf("Enter full path of output image file : ");
	scanf("%s",outputFile);
	
	zhangSuen(inputFile,outputFile);
	
	return 0;
}
