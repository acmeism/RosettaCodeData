#include<unistd.h>
#include<stdio.h>
#include<time.h>

#define DELAY 3000

int main(){
	int i,times;
	
	time_t t;
	struct tm* currentTime;
	
	while(1){
		time(&t);
		currentTime = localtime(&t);
		
		times = (currentTime->tm_hour%12==0)?12:currentTime->tm_hour%12;
		
		if(currentTime->tm_min==0 && currentTime->tm_sec==0){
			printf("\nIt is now %d:00 %s. Sounding the bell %d times.",times,(currentTime->tm_hour>11)?"PM":"AM",times);
		
			for(i=0;i<times;i++){
				printf("\a");
				sleep(DELAY);
			}
		}
		
		else if(currentTime->tm_min==30 && currentTime->tm_sec==0){
			printf("\nIt is now %d:30 %s. Sounding the bell once.",times,(currentTime->tm_hour>11)?"PM":"AM");
			printf("\a");
		}
	}
	
	return 0;
}
