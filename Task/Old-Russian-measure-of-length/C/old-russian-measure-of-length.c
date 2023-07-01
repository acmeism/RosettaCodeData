#include<string.h>
#include<stdlib.h>
#include<ctype.h>
#include<stdio.h>

#define UNITS_LENGTH 13

int main(int argC,char* argV[])
{
	int i,reference;
	char *units[UNITS_LENGTH] = {"kilometer","meter","centimeter","tochka","liniya","diuym","vershok","piad","fut","arshin","sazhen","versta","milia"};
    double factor, values[UNITS_LENGTH] = {1000.0,1.0,0.01,0.000254,0.00254,0.0254,0.04445,0.1778,0.3048,0.7112,2.1336,1066.8,7467.6};
	
	if(argC!=3)
		printf("Usage : %s followed by length as <value> <unit>");
	else{
		for(i=0;argV[2][i]!=00;i++)
			argV[2][i] = tolower(argV[2][i]);
		
		for(i=0;i<UNITS_LENGTH;i++){
			if(strstr(argV[2],units[i])!=NULL){
				reference = i;
				factor = atof(argV[1])*values[i];
				break;
			}
		}
		
		printf("%s %s is equal in length to : \n",argV[1],argV[2]);
		
		for(i=0;i<UNITS_LENGTH;i++){
			if(i!=reference)
				printf("\n%lf %s",factor/values[i],units[i]);
		}
	}
	
	return 0;
}
