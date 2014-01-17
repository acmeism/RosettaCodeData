/*Abhishek Ghosh, 6th November 2013, Rotterdam*/
#include<graphics.h>
#include<conio.h>

int main()
{
	int d=DETECT,m,maxX,maxY,maxColours,i;
	initgraph(&d,&m,"c:/turboc3/bgi");
	maxX = getmaxx();
	maxY = getmaxy();
	maxColours = getmaxcolor();

	for(i=0;i<maxColours;i++)
	{
		setfillstyle(SOLID_FILL,i);
		bar(i*maxX/maxColours,0,(i+1)*maxX/maxColours,maxY);
	}

	getch();
	closegraph();
	
	return 0;
}
