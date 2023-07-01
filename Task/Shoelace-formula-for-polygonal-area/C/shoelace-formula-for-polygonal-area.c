#include<stdlib.h>
#include<stdio.h>
#include<math.h>

typedef struct{
	double x,y;
}point;

double shoelace(char* inputFile){
	int i,numPoints;
	double leftSum = 0,rightSum = 0;
	
	point* pointSet;
	FILE* fp = fopen(inputFile,"r");
	
	fscanf(fp,"%d",&numPoints);
	
	pointSet = (point*)malloc((numPoints + 1)*sizeof(point));
	
	for(i=0;i<numPoints;i++){
		fscanf(fp,"%lf %lf",&pointSet[i].x,&pointSet[i].y);
	}
	
	fclose(fp);
	
	pointSet[numPoints] = pointSet[0];
	
	for(i=0;i<numPoints;i++){
		leftSum += pointSet[i].x*pointSet[i+1].y;
		rightSum += pointSet[i+1].x*pointSet[i].y;
	}
	
	free(pointSet);
	
	return 0.5*fabs(leftSum - rightSum);
}

int main(int argC,char* argV[])
{
	if(argC==1)
		printf("\nUsage : %s <full path of polygon vertices file>",argV[0]);
	
	else
		printf("The polygon area is %lf square units.",shoelace(argV[1]));
	
	return 0;
}
