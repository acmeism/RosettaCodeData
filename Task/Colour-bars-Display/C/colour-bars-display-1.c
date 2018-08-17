#include<conio.h>

#define COLOURS 8

int main()
{
	int colour=0,i,j,MAXROW,MAXCOL;
	struct text_info tInfo;
	gettextinfo(&tInfo);
	MAXROW = tInfo.screenheight;
	MAXCOL = tInfo.screenwidth;
	textbackground(BLACK);     //8 colour constants are defined
	clrscr();
	
	for(colour=0;colour<COLOURS;colour++)
	{
		getch();                              //waits for a key hit
		gotoxy(1+colour*MAXCOL/COLOURS,1);
		textbackground(colour);
		for(j=0;j<MAXROW;j++){
			for(i=0;i<MAXCOL/COLOURS;i++){
				cprintf(" ");
			}
		gotoxy(1+colour*MAXCOL/COLOURS,1+j);
		}
	}

	getch();
	textbackground(BLACK);

	return 0;
}
