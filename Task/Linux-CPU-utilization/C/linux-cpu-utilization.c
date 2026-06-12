#include<stdlib.h>
#include<string.h>
#include<unistd.h>
#include<stdio.h>

int main(int argC,char* argV[])
{
	char str[100];
	const char d[2] = " ";
	char* token;
	int i = 0,times,lag;
	long int sum = 0, idle, lastSum = 0,lastIdle = 0;
	long double idleFraction;
	
	if(argC!=3)
		printf("Usage : %s <number of times /proc/stat should be polled followed by delay in seconds.>",argV[0]);
	
	else{
		times = atoi(argV[1]);
		lag = atoi(argV[2]);
		
		while(times>0){
			FILE* fp = fopen("/proc/stat","r");
	                i = 0;
			fgets(str,100,fp);
			fclose(fp);
			token = strtok(str,d);
	                sum = 0;
			while(token!=NULL){
				token = strtok(NULL,d);
				if(token!=NULL){
					sum += atoi(token);
			
				if(i==3)
					idle = atoi(token);
		
				i++;
			        }
		        }
	                idleFraction = 100 - (idle-lastIdle)*100.0/(sum-lastSum);
		        printf("Busy for : %lf %% of the time.", idleFraction);
	
		        lastIdle = idle;
		        lastSum = sum;
	
		
		        times--;
		        sleep(lag);
		}	
	}
	return 0;
}
