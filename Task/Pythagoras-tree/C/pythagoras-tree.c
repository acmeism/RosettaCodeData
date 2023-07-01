#include<graphics.h>
#include<stdlib.h>
#include<stdio.h>
#include<time.h>

typedef struct{
	double x,y;
}point;

void pythagorasTree(point a,point b,int times){
	
	point c,d,e;
	
	c.x = b.x - (a.y -  b.y);
	c.y = b.y - (b.x - a.x);
	
	d.x = a.x - (a.y -  b.y);
	d.y = a.y - (b.x - a.x);
	
	e.x = d.x +  ( b.x - a.x - (a.y -  b.y) ) / 2;
	e.y = d.y -  ( b.x - a.x + a.y -  b.y ) / 2;
	
	if(times>0){
		setcolor(rand()%15 + 1);
		
		line(a.x,a.y,b.x,b.y);
		line(c.x,c.y,b.x,b.y);
		line(c.x,c.y,d.x,d.y);
		line(a.x,a.y,d.x,d.y);
		
		pythagorasTree(d,e,times-1);
		pythagorasTree(e,c,times-1);
	}
}

int main(){
	
	point a,b;
	double side;
	int iter;
	
	time_t t;
	
	printf("Enter initial side length : ");
	scanf("%lf",&side);
	
	printf("Enter number of iterations : ");
	scanf("%d",&iter);
	
	a.x = 6*side/2 - side/2;
	a.y = 4*side;
	b.x = 6*side/2 + side/2;
	b.y = 4*side;
	
	initwindow(6*side,4*side,"Pythagoras Tree ?");
	
	srand((unsigned)time(&t));
	
	pythagorasTree(a,b,iter);
	
	getch();
	
	closegraph();
	
	return 0;

}
