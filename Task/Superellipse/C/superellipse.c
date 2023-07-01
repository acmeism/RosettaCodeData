#include<graphics.h>
#include<stdio.h>
#include<math.h>

#define pi M_PI

int main(){
	
	double a,b,n,i,incr = 0.0001;
	
	printf("Enter major and minor axes of the SuperEllipse : ");
	scanf("%lf%lf",&a,&b);
	
	printf("Enter n : ");
	scanf("%lf",&n);
	
	initwindow(500,500,"Superellipse");
	
	for(i=0;i<2*pi;i+=incr){
		putpixel(250 + a*pow(fabs(cos(i)),2/n)*(pi/2<i && i<3*pi/2?-1:1),250 + b*pow(fabs(sin(i)),2/n)*(pi<i && i<2*pi?-1:1),15);
	}
	
	printf("Done. %lf",i);
	
	getch();
	
	closegraph();
}
