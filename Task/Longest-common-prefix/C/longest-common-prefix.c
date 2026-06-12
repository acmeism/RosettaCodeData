#include<stdarg.h>
#include<string.h>
#include<stdlib.h>
#include<stdio.h>

char* lcp(int num,...){
	va_list vaList,vaList2;
	int i,j,len,min;
	char* dest;
	char** strings = (char**)malloc(num*sizeof(char*));
	
	va_start(vaList,num);
	va_start(vaList2,num);
	
	for(i=0;i<num;i++){
		len = strlen(va_arg(vaList,char*));
		strings[i] = (char*)malloc((len + 1)*sizeof(char));
		
		strcpy(strings[i],va_arg(vaList2,char*));
		
		if(i==0)
			min = len;
		else if(len<min)
			min = len;
	}
	
	if(min==0)
		return "";
	
	for(i=0;i<min;i++){
		for(j=1;j<num;j++){
			if(strings[j][i]!=strings[0][i]){
				if(i==0)
					return "";
				else{
					dest = (char*)malloc(i*sizeof(char));
					strncpy(dest,strings[0],i-1);
					return dest;
				}
			}
		}
	}
	
	dest = (char*)malloc((min+1)*sizeof(char));
	strncpy(dest,strings[0],min);
	return dest;
}

int main(){

	printf("\nLongest common prefix : %s",lcp(3,"interspecies","interstellar","interstate"));
        printf("\nLongest common prefix : %s",lcp(2,"throne","throne"));
        printf("\nLongest common prefix : %s",lcp(2,"throne","dungeon"));
        printf("\nLongest common prefix : %s",lcp(3,"throne","","throne"));
        printf("\nLongest common prefix : %s",lcp(1,"cheese"));
        printf("\nLongest common prefix : %s",lcp(1,""));
        printf("\nLongest common prefix : %s",lcp(0,NULL));
        printf("\nLongest common prefix : %s",lcp(2,"prefix","suffix"));
        printf("\nLongest common prefix : %s",lcp(2,"foo","foobar"));
	return 0;
}
