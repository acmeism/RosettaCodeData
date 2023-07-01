#include<stdlib.h>
#include<stdio.h>

int cusipCheck(char str[10]){
	int sum=0,i,v;
	
	for(i=0;i<8;i++){
		if(str[i]>='0'&&str[i]<='9')
			v = str[i]-'0';
		else if(str[i]>='A'&&str[i]<='Z')
			v = (str[i] - 'A' + 10);
		else if(str[i]=='*')
			v = 36;
		else if(str[i]=='@')
			v = 37;
		else if(str[i]=='#')
			v = 38;
		if(i%2!=0)
			v*=2;
		
		sum += ((int)(v/10) + v%10);
	}
	return ((10 - (sum%10))%10);
}

int main(int argC,char* argV[])
{
	char cusipStr[10];
	
	int i,numLines;
	
	if(argC==1)
		printf("Usage : %s <full path of CUSIP Data file>",argV[0]);
	
	else{
		FILE* fp = fopen(argV[1],"r");
	
		fscanf(fp,"%d",&numLines);
		
		printf("CUSIP       Verdict\n");
		printf("-------------------");
		
		for(i=0;i<numLines;i++){
		
			fscanf(fp,"%s",cusipStr);
		
			printf("\n%s : %s",cusipStr,(cusipCheck(cusipStr)==(cusipStr[8]-'0'))?"Valid":"Invalid");
		}
	
		fclose(fp);
	}
	return 0;
}
