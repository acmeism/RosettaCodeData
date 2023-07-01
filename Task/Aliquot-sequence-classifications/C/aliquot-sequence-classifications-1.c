#include<stdlib.h>
#include<string.h>
#include<stdio.h>

unsigned long long bruteForceProperDivisorSum(unsigned long long n){
	unsigned long long i,sum = 0;
	
	for(i=1;i<(n+1)/2;i++)
		if(n%i==0 && n!=i)
			sum += i;
		
	return sum;
}

void printSeries(unsigned long long* arr,int size,char* type){
	int i;
	
	printf("\nInteger : %llu, Type : %s, Series : ",arr[0],type);
	
	for(i=0;i<size-1;i++)
		printf("%llu, ",arr[i]);
	printf("%llu",arr[i]);
}

void aliquotClassifier(unsigned long long n){
	unsigned long long arr[16];
	int i,j;
	
	arr[0] = n;
	
	for(i=1;i<16;i++){
		arr[i] = bruteForceProperDivisorSum(arr[i-1]);
		
		if(arr[i]==0||arr[i]==n||(arr[i]==arr[i-1] && arr[i]!=n)){
			printSeries(arr,i+1,(arr[i]==0)?"Terminating":(arr[i]==n && i==1)?"Perfect":(arr[i]==n && i==2)?"Amicable":(arr[i]==arr[i-1] && arr[i]!=n)?"Aspiring":"Sociable");
			return;
		}
		
		for(j=1;j<i;j++){
			if(arr[j]==arr[i]){
				printSeries(arr,i+1,"Cyclic");
				return;
			}
		}
	}
	
	printSeries(arr,i+1,"Non-Terminating");
}

void processFile(char* fileName){
	FILE* fp = fopen(fileName,"r");
	char str[21];
	
	while(fgets(str,21,fp)!=NULL)
		aliquotClassifier(strtoull(str,(char**)NULL,10));
	
	fclose(fp);
}

int main(int argC,char* argV[])
{
    if(argC!=2)
		printf("Usage : %s <positive integer>",argV[0]);
	else{
		if(strchr(argV[1],'.')!=NULL)
			processFile(argV[1]);
		else
			aliquotClassifier(strtoull(argV[1],(char**)NULL,10));
	}
	return 0;
}
