#include<graphics.h>
#include<stdlib.h>
#include<stdio.h>
#include<time.h>

void barnsleyFern(int windowWidth, unsigned long iter){
	
	double x0=0,y0=0,x1,y1;
	int diceThrow;
	time_t t;
	srand((unsigned)time(&t));
	
	while(iter>0){
		diceThrow = rand()%100;
		
		if(diceThrow==0){
			x1 = 0;
			y1 = 0.16*y0;
		}
		
		else if(diceThrow>=1 && diceThrow<=7){
			x1 = -0.15*x0 + 0.28*y0;
			y1 = 0.26*x0 + 0.24*y0 + 0.44;
		}
		
		else if(diceThrow>=8 && diceThrow<=15){
			x1 = 0.2*x0 - 0.26*y0;
			y1 = 0.23*x0 + 0.22*y0 + 1.6;
		}
		
		else{
			x1 = 0.85*x0 + 0.04*y0;
			y1 = -0.04*x0 + 0.85*y0 + 1.6;
		}
		
		putpixel(30*x1 + windowWidth/2.0,30*y1,GREEN);
		
		x0 = x1;
		y0 = y1;
		
		iter--;
	}

}

int main()
{
	unsigned long num;
	
	printf("Enter number of iterations : ");
	scanf("%ld",&num);
	
	initwindow(500,500,"Barnsley Fern");
	
	barnsleyFern(500,num);
	
	getch();
	
	closegraph();
	
	return 0;
}
