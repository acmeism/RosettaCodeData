#include<graphics.h>
#include<stdlib.h>
#include<stdio.h>
#include<math.h>
#include<time.h>

#define pi M_PI

int main(){
	
	time_t t;
	double side, vertices[3][3],seedX,seedY,windowSide;
	int i,iter,choice;
	
	printf("Enter triangle side length : ");
	scanf("%lf",&side);
	
	printf("Enter number of iterations : ");
	scanf("%d",&iter);
	
	windowSide = 10 + 2*side;

	initwindow(windowSide,windowSide,"Sierpinski Chaos");
	
	for(i=0;i<3;i++){
		vertices[i][0] = windowSide/2 + side*cos(i*2*pi/3);
		vertices[i][1] = windowSide/2 + side*sin(i*2*pi/3);
		putpixel(vertices[i][0],vertices[i][1],15);
	}
	
	srand((unsigned)time(&t));
	
	seedX = rand()%(int)(vertices[0][0]/2 + (vertices[1][0] + vertices[2][0])/4);
	seedY = rand()%(int)(vertices[0][1]/2 + (vertices[1][1] + vertices[2][1])/4);
	
	putpixel(seedX,seedY,15);
	
	for(i=0;i<iter;i++){
		choice = rand()%3;
		
		seedX = (seedX + vertices[choice][0])/2;
		seedY = (seedY + vertices[choice][1])/2;
		
		putpixel(seedX,seedY,15);
	}
	
	getch();
	
	closegraph();
	
	return 0;
}
