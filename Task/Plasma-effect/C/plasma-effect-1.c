#include<windows.h>
#include<stdlib.h>
#include<stdio.h>
#include<time.h>
#include<math.h>

#define pi M_PI

int main()
{
	CONSOLE_SCREEN_BUFFER_INFO info;
    int cols, rows;
	time_t t;
	int i,j;

    GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), &info);
    cols = info.srWindow.Right - info.srWindow.Left + 1;
    rows = info.srWindow.Bottom - info.srWindow.Top + 1;
	
	HANDLE console;
	
	console = GetStdHandle(STD_OUTPUT_HANDLE);
	
	system("@clear||cls");
	
	srand((unsigned)time(&t));
	
	for(i=0;i<rows;i++)
		for(j=0;j<cols;j++){
			SetConsoleTextAttribute(console,fabs(sin(pi*(rand()%254 + 1)/255.0))*254);
			printf("%c",219);
		}
		
	getchar();
	
	return 0;
}
