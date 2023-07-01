#include<graphics.h>
#include<math.h>

#define factor M_PI/180
#define LAG 1000

void polySpiral(int windowWidth,int	windowHeight){
	int incr = 0, angle, i, length;
	double x,y,x1,y1;
	
	while(1){
		incr = (incr + 5)%360;
		
		x = windowWidth/2;
		y = windowHeight/2;
		
		length = 5;
		angle = incr;
		
		for(i=1;i<=150;i++){
			x1 = x + length*cos(factor*angle);
			y1 = y + length*sin(factor*angle);
			line(x,y,x1,y1);
			
			length += 3;
			
			angle = (angle + incr)%360;
			
			x = x1;
			y = y1;
		}
		delay(LAG);
		cleardevice();	
	}
}	

int main()
{
	initwindow(500,500,"Polyspiral");
	
	polySpiral(500,500);
	
	closegraph();
	
	return 0;
}
