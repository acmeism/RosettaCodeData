#include<curl/curl.h>
#include<string.h>
#include<stdio.h>

#define MAX_LEN 1000

void searchChatLogs(char* searchString){
	char* baseURL = "http://tclers.tk/conferences/tcl/";
	time_t t;
	struct tm* currentDate;
	char dateString[30],dateStringFile[30],lineData[MAX_LEN],targetURL[100];
	int i,flag;
	FILE *fp;
	
	CURL *curl;
	CURLcode res;
	
	time(&t);
	currentDate = localtime(&t);
	
	strftime(dateString, 30, "%Y-%m-%d", currentDate);
	printf("Today is : %s",dateString);
	
	if((curl = curl_easy_init())!=NULL){
		for(i=0;i<=10;i++){
			
		flag = 0;
		sprintf(targetURL,"%s%s.tcl",baseURL,dateString);
		
		strcpy(dateStringFile,dateString);
		
		printf("\nRetrieving chat logs from %s\n",targetURL);
		
		if((fp = fopen("nul","w"))==0){
			printf("Cant's read from %s",targetURL);
		}
		else{
			curl_easy_setopt(curl, CURLOPT_URL, targetURL);
		curl_easy_setopt(curl, CURLOPT_WRITEDATA, fp);
		
		res = curl_easy_perform(curl);
		
		if(res == CURLE_OK){
			while(fgets(lineData,MAX_LEN,fp)!=NULL){
				if(strstr(lineData,searchString)!=NULL){
					flag = 1;
					fputs(lineData,stdout);
				}
			}
			
			if(flag==0)
				printf("\nNo matching lines found.");
		}
		fflush(fp);
		fclose(fp);
		}
		
		currentDate->tm_mday--;
		mktime(currentDate);
		strftime(dateString, 30, "%Y-%m-%d", currentDate);	
			
	}
	curl_easy_cleanup(curl);
	
	}
}

int main(int argC,char* argV[])
{
	if(argC!=2)
		printf("Usage : %s <followed by search string, enclosed by \" if it contains spaces>",argV[0]);
	else
		searchChatLogs(argV[1]);
	return 0;
}
