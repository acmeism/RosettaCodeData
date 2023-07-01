#include<graphics.h>
#include<stdlib.h>
#include<stdio.h>
#include<math.h>

#define pi M_PI

typedef struct{
	double x,y;
}point;

void kochCurve(point p1,point p2,int times){
	point p3,p4,p5;
	double theta = pi/3;
	
	if(times>0){
		p3 = (point){(2*p1.x+p2.x)/3,(2*p1.y+p2.y)/3};
		p5 = (point){(2*p2.x+p1.x)/3,(2*p2.y+p1.y)/3};
		
		p4 = (point){p3.x + (p5.x - p3.x)*cos(theta) + (p5.y - p3.y)*sin(theta),p3.y - (p5.x - p3.x)*sin(theta) + (p5.y - p3.y)*cos(theta)};
		
		kochCurve(p1,p3,times-1);
		kochCurve(p3,p4,times-1);
		kochCurve(p4,p5,times-1);
		kochCurve(p5,p2,times-1);
	}
	
	else{
		line(p1.x,p1.y,p2.x,p2.y);
	}
}

int main(int argC, char** argV)
{
	int w,h,r;
	point p1,p2;
	
	if(argC!=4){
		printf("Usage : %s <window width> <window height> <recursion level>",argV[0]);
	}
	
	else{
		w = atoi(argV[1]);
		h = atoi(argV[2]);
		r = atoi(argV[3]);
		
		initwindow(w,h,"Koch Curve");
		
		p1 = (point){10,h-10};
		p2 = (point){w-10,h-10};
		
		kochCurve(p1,p2,r);
		
		getch();
	
		closegraph();
	}
	
	return 0;
}
