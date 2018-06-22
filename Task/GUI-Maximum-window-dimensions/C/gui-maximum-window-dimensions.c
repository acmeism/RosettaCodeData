/*Abhishek Ghosh, 3rd October 2017*/

#include<windows.h>
#include<stdio.h>

int main()
{
	printf("Dimensions of the screen are (w x h) : %d x %d pixels",GetSystemMetrics(SM_CXSCREEN),GetSystemMetrics(SM_CYSCREEN));
	return 0;
}
