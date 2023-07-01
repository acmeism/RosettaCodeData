#include<graphics.h>
#include<stdio.h>
#include<math.h>

#define pi M_PI

int main(){
	
	char colourNames[][14] = { "BLACK", "BLUE", "GREEN", "CYAN", "RED", "MAGENTA", "BROWN", "LIGHTGRAY", "DARKGRAY",
              "LIGHTBLUE", "LIGHTGREEN", "LIGHTCYAN", "LIGHTRED", "LIGHTMAGENTA", "YELLOW", "WHITE" };
			
	int stroke=0,fill=0,back=0,i;
	
	double centerX = 300,centerY = 300,coreSide,armLength,pentaLength;
	
	printf("Enter core pentagon side length : ");
	scanf("%lf",&coreSide);
	
	printf("Enter pentagram arm length : ");
	scanf("%lf",&armLength);
	
	printf("Available colours are :\n");
	
	for(i=0;i<16;i++){
		printf("%d. %s\t",i+1,colourNames[i]);
		if((i+1) % 3 == 0){
			printf("\n");
		}
	}
	
	while(stroke==fill && fill==back){
		printf("\nEnter three diffrenet options for stroke, fill and background : ");
		scanf("%d%d%d",&stroke,&fill,&back);
	}
	
	pentaLength = coreSide/(2 * tan(pi/5)) + sqrt(armLength*armLength - coreSide*coreSide/4);
	
	initwindow(2*centerX,2*centerY,"Pentagram");
		
	setcolor(stroke-1);
	
	setfillstyle(SOLID_FILL,back-1);
	
	bar(0,0,2*centerX,2*centerY);
	
	floodfill(centerX,centerY,back-1);
	
	setfillstyle(SOLID_FILL,fill-1);

	for(i=0;i<5;i++){
		line(centerX + coreSide*cos(i*2*pi/5)/(2*sin(pi/5)),centerY + coreSide*sin(i*2*pi/5)/(2*sin(pi/5)),centerX + coreSide*cos((i+1)*2*pi/5)/(2*sin(pi/5)),centerY + coreSide*sin((i+1)*2*pi/5)/(2*sin(pi/5)));
		line(centerX + coreSide*cos(i*2*pi/5)/(2*sin(pi/5)),centerY + coreSide*sin(i*2*pi/5)/(2*sin(pi/5)),centerX + pentaLength*cos(i*2*pi/5 + pi/5),centerY + pentaLength*sin(i*2*pi/5 + pi/5));
		line(centerX + coreSide*cos((i+1)*2*pi/5)/(2*sin(pi/5)),centerY + coreSide*sin((i+1)*2*pi/5)/(2*sin(pi/5)),centerX + pentaLength*cos(i*2*pi/5 + pi/5),centerY + pentaLength*sin(i*2*pi/5 + pi/5));
		
		floodfill(centerX + coreSide*cos(i*2*pi/5 + pi/10)/(2*sin(pi/5)),centerY + coreSide*sin(i*2*pi/5 + pi/10)/(2*sin(pi/5)),stroke-1);
	}
	
	floodfill(centerX,centerY,stroke-1);
	
	getch();
	
	closegraph();
}
