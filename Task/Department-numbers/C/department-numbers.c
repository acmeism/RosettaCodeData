#include<stdio.h>

int main()
{
	int police,sanitation,fire;
	
	printf("Police     Sanitation         Fire\n");
	printf("----------------------------------");
	
	for(police=2;police<=6;police+=2){
		for(sanitation=1;sanitation<=7;sanitation++){
			for(fire=1;fire<=7;fire++){
				if(police!=sanitation && sanitation!=fire && fire!=police && police+fire+sanitation==12){
					printf("\n%d\t\t%d\t\t%d",police,sanitation,fire);
				}
			}
		}
	}
	
	return 0;
}
