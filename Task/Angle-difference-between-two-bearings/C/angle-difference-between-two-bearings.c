#include<stdlib.h>
#include<stdio.h>
#include<math.h>

void processFile(char* name){
	
	int i,records;
	double diff,b1,b2;
	FILE* fp = fopen(name,"r");
	
	fscanf(fp,"%d\n",&records);
	
	for(i=0;i<records;i++){
		fscanf(fp,"%lf%lf",&b1,&b2);
		
		diff = fmod(b2-b1,360.0);
		printf("\nDifference between b2(%lf) and b1(%lf) is %lf",b2,b1,(diff<-180)?diff+360:((diff>=180)?diff-360:diff));	
	}
	
	fclose(fp);
}

int main(int argC,char* argV[])
{
	double diff;
	
	if(argC < 2)
		printf("Usage : %s <bearings separated by a space OR full file name which contains the bearing list>",argV[0]);
	else if(argC == 2)
		processFile(argV[1]);
	else{
		diff = fmod(atof(argV[2])-atof(argV[1]),360.0);
		printf("Difference between b2(%s) and b1(%s) is %lf",argV[2],argV[1],(diff<-180)?diff+360:((diff>=180)?diff-360:diff));
	}

	return 0;
}
