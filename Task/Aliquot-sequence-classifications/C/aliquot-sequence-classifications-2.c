#include<string.h>
#include<stdlib.h>
#include<stdio.h>

unsigned long long raiseTo(unsigned long long base, unsigned long long power){
    unsigned long long result = 1,i;
    for (i=0; i<power;i++) {
        result*=base;
    }
    return result;
}

unsigned long long properDivisorSum(unsigned long long n){
	unsigned long long prod = 1;
	unsigned long long temp = n,i,count = 0;

	while(n%2 == 0){
		count++;
		n /= 2;
	}
	
	if(count!=0)
		prod *= (raiseTo(2,count + 1) - 1);

	for(i=3;i*i<=n;i+=2){
		count = 0;
		
		while(n%i == 0){
			count++;
			n /= i;
		}
		
		if(count==1)
			prod *= (i+1);
		else if(count > 1)
			prod *= ((raiseTo(i,count + 1) - 1)/(i-1));
	}
	
	if(n>2)
		prod *= (n+1);

	return prod - temp;
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
		arr[i] = properDivisorSum(arr[i-1]);
		
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
