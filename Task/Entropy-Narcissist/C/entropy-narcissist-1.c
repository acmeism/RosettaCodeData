#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>

#define MAXLEN 961 //maximum string length

int makehist(char *S,int *hist,int len){
	int wherechar[256];
	int i,histlen;
	histlen=0;
	for(i=0;i<256;i++)wherechar[i]=-1;
	for(i=0;i<len;i++){
		if(wherechar[(int)S[i]]==-1){
			wherechar[(int)S[i]]=histlen;
			histlen++;
		}
		hist[wherechar[(int)S[i]]]++;
	}
	return histlen;
}

double entropy(int *hist,int histlen,int len){
	int i;
	double H;
	H=0;
	for(i=0;i<histlen;i++){
		H-=(double)hist[i]/len*log2((double)hist[i]/len);
	}
	return H;
}

int main(void){
	char S[MAXLEN];
	int len,*hist,histlen;
	double H;
	FILE *f;
	f=fopen("entropy.c","r");
	for(len=0;!feof(f);len++)S[len]=fgetc(f);
	S[--len]='\0';
	hist=(int*)calloc(len,sizeof(int));
	histlen=makehist(S,hist,len);
	//hist now has no order (known to the program) but that doesn't matter
	H=entropy(hist,histlen,len);
	printf("%lf\n",H);
	return 0;
}
