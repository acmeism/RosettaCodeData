#include<stdlib.h>
#include<stdio.h>
#include<wchar.h>

#define ENCRYPT 0
#define DECRYPT 1
#define ALPHA 33
#define OMEGA 126

int wideStrLen(wchar_t* str){
	int i = 0;
	while(str[i++]!=00);
	
	return i;
}

void processFile(char* fileName,char plainKey, char cipherKey,int flag){
	
	FILE* inpFile = fopen(fileName,"r");
	FILE* outFile;
	
	int i,len, diff = (flag==ENCRYPT)?(int)cipherKey - (int)plainKey:(int)plainKey - (int)cipherKey;
	wchar_t str[1000], *outStr;
	char* outFileName = (char*)malloc((strlen(fileName)+5)*sizeof(char));

	sprintf(outFileName,"%s_%s",fileName,(flag==ENCRYPT)?"ENC":"DEC");
	
	outFile = fopen(outFileName,"w");
	
	while(fgetws(str,1000,inpFile)!=NULL){
		len = wideStrLen(str);
		
		outStr = (wchar_t*)malloc((len + 1)*sizeof(wchar_t));
		
		for(i=0;i<len;i++){
			if((int)str[i]>=ALPHA && (int)str[i]<=OMEGA && flag == ENCRYPT)
				outStr[i] = (wchar_t)((int)str[i]+diff);
			 else if((int)str[i]-diff>=ALPHA && (int)str[i]-diff<=OMEGA && flag == DECRYPT)
				outStr[i] = (wchar_t)((int)str[i]-diff);
			else
				outStr[i] = str[i];
		}
		outStr[i]=str[i];
		
		fputws(outStr,outFile);
		
		free(outStr);
	}
	
	fclose(inpFile);
	fclose(outFile);
}

int main(int argC,char* argV[]){
	if(argC!=5)
		printf("Usage : %s <file name, plain key, cipher key, action (E)ncrypt or (D)ecrypt>",argV[0]);
	else{
		processFile(argV[1],argV[2][0],argV[3][0],(argV[4][0]=='E'||argV[4][0]=='e')?ENCRYPT:DECRYPT);
		
		printf("File %s_%s has been written to the same location as input file.",argV[1],(argV[4][0]=='E'||argV[4][0]=='e')?"ENC":"DEC");
	}
	
	return 0;
}
