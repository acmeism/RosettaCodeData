#include<unistd.h>
#include<stdio.h>
#include<time.h>

#define SHORTLAG 1000
#define LONGLAG  2000

int main(){
	int i,times,hour,min,sec,min1,min2;
	
	time_t t;
	struct tm* currentTime;
	
	while(1){
		time(&t);
		currentTime = localtime(&t);
		
		hour = currentTime->tm_hour;
		min = currentTime->tm_min;
		sec = currentTime->tm_sec;
		
		hour = 12;
		min = 0;
		sec = 0;
		
		if((min==0 || min==30) && sec==0)
			times = ((hour*60 + min)%240)%8;
		if(times==0){
			times = 8;
		}	

		if(min==0){
			min1 = 0;
			min2 = 0;
		}
		
		else{
			min1 = 3;
			min2 = 0;
		}
		
		if((min==0 || min==30) && sec==0){
			printf("\nIt is now %d:%d%d %s. Sounding the bell %d times.",hour,min1,min2,(hour>11)?"PM":"AM",times);
		
			for(i=1;i<=times;i++){
				printf("\a");
				
				(i%2==0)?sleep(LONGLAG):sleep(SHORTLAG);
			}
		}
	}
	return 0;
}
