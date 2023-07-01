/*Abhishek Ghosh, 14th September 2018*/

#include <graphics.h>
#include <math.h>

void Peano(int x, int y, int lg, int i1, int i2) {

	if (lg == 1) {
		lineto(3*x,3*y);
		return;
	}
	
	lg = lg/3;
	Peano(x+(2*i1*lg), y+(2*i1*lg), lg, i1, i2);
	Peano(x+((i1-i2+1)*lg), y+((i1+i2)*lg), lg, i1, 1-i2);
	Peano(x+lg, y+lg, lg, i1, 1-i2);
	Peano(x+((i1+i2)*lg), y+((i1-i2+1)*lg), lg, 1-i1, 1-i2);
	Peano(x+(2*i2*lg), y+(2*(1-i2)*lg), lg, i1, i2);
	Peano(x+((1+i2-i1)*lg), y+((2-i1-i2)*lg), lg, i1, i2);
	Peano(x+(2*(1-i1)*lg), y+(2*(1-i1)*lg), lg, i1, i2);
	Peano(x+((2-i1-i2)*lg), y+((1+i2-i1)*lg), lg, 1-i1, i2);
	Peano(x+(2*(1-i2)*lg), y+(2*i2*lg), lg, 1-i1, i2);
}

int main(void) {

	initwindow(1000,1000,"Peano, Peano");

	Peano(0, 0, 1000, 0, 0); /* Start Peano recursion. */
	
	getch();
	cleardevice();
	
	return 0;
}
