#include<graphics.h>
#include<stdlib.h>
#include<math.h>
#include<time.h>

#define pi M_PI

void plasmaScreen(int width,int height){
	
	int x,y,sec;
	double dx,dy,dv;
	time_t t;
	
	initwindow(width,height,"WinBGIm Plasma");
	
	while(1){
		time(&t);
		sec = (localtime(&t))->tm_sec;
		
	for(x=0;x<width;x++)
		for(y=0;y<height;y++){
			dx = x + .5 * sin(sec/5.0);
			dy = y + .5 * cos(sec/3.0);
			
			dv = sin(x*10 + sec) + sin(10*(x*sin(sec/2.0) + y*cos(sec/3.0)) + sec) + sin(sqrt(100*(dx*dx + dy*dy)+1) + sec);
			
			setcolor(COLOR(255*fabs(sin(dv*pi)),255*fabs(sin(dv*pi + 2*pi/3)),255*fabs(sin(dv*pi + 4*pi/3))));
			
			putpixel(x,y,getcolor());
		}
	delay(1000);
	}
}

int main(int argC,char* argV[])
{
	if(argC != 3)
		printf("Usage : %s <Two positive integers separated by a space specifying screen size>",argV[0]);
	else{
		plasmaScreen(atoi(argV[1]),atoi(argV[2]));
	}
	return 0;
}
