#include<stdlib.h>
#include<stdio.h>

typedef struct{
	int score;
	char name[100];
}entry;

void ordinalRanking(entry* list,int len){
	
	int i;
	
	printf("\n\nOrdinal Ranking\n---------------");
	
	for(i=0;i<len;i++)
		printf("\n%d\t%d\t%s",i+1,list[i].score,list[i].name);
}

void standardRanking(entry* list,int len){
	
	int i,j=1;
	
	printf("\n\nStandard Ranking\n----------------");
	
	for(i=0;i<len;i++){
		printf("\n%d\t%d\t%s",j,list[i].score,list[i].name);
		if(list[i+1].score<list[i].score)
			j = i+2;
	}
}

void denseRanking(entry* list,int len){
	
	int i,j=1;
	
	printf("\n\nDense Ranking\n-------------");
	
	for(i=0;i<len;i++){
		printf("\n%d\t%d\t%s",j,list[i].score,list[i].name);
		if(list[i+1].score<list[i].score)
			j++;
	}
}

void modifiedRanking(entry* list,int len){
	
	int i,j,count;
	
	printf("\n\nModified Ranking\n----------------");
	
	for(i=0;i<len-1;i++){
		if(list[i].score!=list[i+1].score){
			printf("\n%d\t%d\t%s",i+1,list[i].score,list[i].name);
			count = 1;
			for(j=i+1;list[j].score==list[j+1].score && j<len-1;j++)
				count ++;
			for(j=0;j<count-1;j++)
				printf("\n%d\t%d\t%s",i+count+1,list[i+j+1].score,list[i+j+1].name);
			i += (count-1);
		}
	}
	printf("\n%d\t%d\t%s",len,list[len-1].score,list[len-1].name);
}

void fractionalRanking(entry* list,int len){
	
	int i,j,count;
	float sum = 0;
	
	printf("\n\nFractional Ranking\n------------------");
	
	for(i=0;i<len;i++){
		if(i==len-1 || list[i].score!=list[i+1].score)
			printf("\n%.1f\t%d\t%s",(float)(i+1),list[i].score,list[i].name);
		else if(list[i].score==list[i+1].score){
			sum = i;
			count = 1;
			for(j=i;list[j].score==list[j+1].score;j++){
				sum += (j+1);
				count ++;
			}
			for(j=0;j<count;j++)
				printf("\n%.1f\t%d\t%s",sum/count + 1,list[i+j].score,list[i+j].name);
			i += (count-1);
		}
	}
}

void processFile(char* fileName){
	FILE* fp = fopen(fileName,"r");
	entry* list;
	int i,num;
	
	fscanf(fp,"%d",&num);
	
	list = (entry*)malloc(num*sizeof(entry));
	
	for(i=0;i<num;i++)
		fscanf(fp,"%d%s",&list[i].score,list[i].name);
	
	fclose(fp);
	
	ordinalRanking(list,num);
	standardRanking(list,num);
	denseRanking(list,num);
	modifiedRanking(list,num);
	fractionalRanking(list,num);
}

int main(int argC,char* argV[])
{
	if(argC!=2)
		printf("Usage %s <score list file>");
	else
		processFile(argV[1]);
	return 0;
}
