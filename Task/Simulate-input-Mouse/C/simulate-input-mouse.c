#define WINVER 0x500
#include<windows.h>

int main()
{
	int maxX = GetSystemMetrics(SM_CXSCREEN), maxY = GetSystemMetrics(SM_CYSCREEN);
	int x = maxX/2, y = maxY/2;
	double factorX = 65536.0 / maxX,factorY = 65536.0 / maxY;
	
	INPUT ip;
	
	ZeroMemory(&ip,sizeof(ip));
	
	ip.type = INPUT_MOUSE;
	
	while(x > 5 || y < maxY-5){

	ip.mi.mouseData = 0;
	ip.mi.dx = x * factorX;
	ip.mi.dy = y * factorY;
	ip.mi.dwFlags = MOUSEEVENTF_ABSOLUTE | MOUSEEVENTF_MOVE;
		
	SendInput(1,&ip,sizeof(ip));
	sleep(1);
	if(x>3)	
		x-=1;
	if(y<maxY-3)
		y+=1;
	}
	
	ip.mi.dwFlags = MOUSEEVENTF_ABSOLUTE | MOUSEEVENTF_LEFTDOWN | MOUSEEVENTF_LEFTUP;
	
	SendInput(1,&ip,sizeof(ip));
	
	return 0;
}
