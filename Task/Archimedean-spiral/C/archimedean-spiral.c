#include<graphics.h>
#include<stdio.h>
#include<math.h>

#define pi M_PI

int main(){
	double a,b,cycles,incr,i;
	
	int steps,x=500,y=500;
	
	printf("Enter the parameters a and b : ");
	scanf("%lf%lf",&a,&b);
	
	printf("Enter cycles : ");
	scanf("%lf",&cycles);
	
	printf("Enter divisional steps : ");
	scanf("%d",&steps);
	
	incr = 1.0/steps;
	
	initwindow(1000,1000,"Archimedean Spiral");
	
	for(i=0;i<=cycles*pi;i+=incr){
		putpixel(x + (a + b*i)*cos(i),x + (a + b*i)*sin(i),15);
	}
	
	getch();
	
	closegraph();	
}
