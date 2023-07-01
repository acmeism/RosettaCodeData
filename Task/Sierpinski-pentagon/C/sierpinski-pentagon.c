#include<graphics.h>
#include<stdlib.h>
#include<stdio.h>
#include<math.h>
#include<time.h>

#define pi M_PI

int main(){
	
	time_t t;
	double side, **vertices,seedX,seedY,windowSide = 500,sumX=0,sumY=0;
	int i,iter,choice,numSides;
	
	printf("Enter number of sides : ");
	scanf("%d",&numSides);
	
	printf("Enter polygon side length : ");
	scanf("%lf",&side);
	
	printf("Enter number of iterations : ");
	scanf("%d",&iter);

	initwindow(windowSide,windowSide,"Polygon Chaos");
	
	vertices = (double**)malloc(numSides*sizeof(double*));
	
	for(i=0;i<numSides;i++){
		vertices[i] = (double*)malloc(2 * sizeof(double));
		
		vertices[i][0] = windowSide/2 + side*cos(i*2*pi/numSides);
		vertices[i][1] = windowSide/2 + side*sin(i*2*pi/numSides);
		sumX+= vertices[i][0];
		sumY+= vertices[i][1];
		putpixel(vertices[i][0],vertices[i][1],15);
	}
	
	srand((unsigned)time(&t));
	
	seedX = sumX/numSides;
	seedY = sumY/numSides;
	
	putpixel(seedX,seedY,15);
	
	for(i=0;i<iter;i++){
		choice = rand()%numSides;
		
		seedX = (seedX + (numSides-2)*vertices[choice][0])/(numSides-1);
		seedY = (seedY + (numSides-2)*vertices[choice][1])/(numSides-1);
		
		putpixel(seedX,seedY,15);
	}
	
	free(vertices);
	
	getch();
	
	closegraph();
	
	return 0;
}
