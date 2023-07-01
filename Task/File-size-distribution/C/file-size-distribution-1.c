#include<windows.h>
#include<string.h>
#include<stdio.h>

#define MAXORDER 25

int main(int argC, char* argV[])
{
	char str[MAXORDER],commandString[1000],*startPath;
	long int* fileSizeLog = (long int*)calloc(sizeof(long int),MAXORDER),max;
	int i,j,len;
	double scale;
	FILE* fp;

	if(argC==1)
		printf("Usage : %s <followed by directory to start search from(. for current dir), followed by \n optional parameters (T or G) to show text or graph output>",argV[0]);
	else{
		if(strchr(argV[1],' ')!=NULL){
		len = strlen(argV[1]);
		startPath = (char*)malloc((len+2)*sizeof(char));
		startPath[0] = '\"';
		startPath[len+1]='\"';
		strncpy(startPath+1,argV[1],len);
		startPath[len+2] = argV[1][len];
		sprintf(commandString,"forfiles /p %s /s /c \"cmd /c echo @fsize\" 2>&1",startPath);
	}

	else if(strlen(argV[1])==1 && argV[1][0]=='.')
		strcpy(commandString,"forfiles /s /c \"cmd /c echo @fsize\" 2>&1");

	else
		sprintf(commandString,"forfiles /p %s /s /c \"cmd /c echo @fsize\" 2>&1",argV[1]);

	fp = popen(commandString,"r");

	while(fgets(str,100,fp)!=NULL){
			if(str[0]=='0')
				fileSizeLog[0]++;
			else
				fileSizeLog[strlen(str)]++;
	}

	if(argC==2 || (argC==3 && (argV[2][0]=='t'||argV[2][0]=='T'))){
		for(i=0;i<MAXORDER;i++){
			printf("\nSize Order < 10^%2d bytes : %Ld",i,fileSizeLog[i]);
		}
	}

	else if(argC==3 && (argV[2][0]=='g'||argV[2][0]=='G')){
		CONSOLE_SCREEN_BUFFER_INFO csbi;
		int val = GetConsoleScreenBufferInfo(GetStdHandle( STD_OUTPUT_HANDLE ),&csbi);
		if(val)
		{

				max = fileSizeLog[0];

				for(i=1;i<MAXORDER;i++)
					(fileSizeLog[i]>max)?max=fileSizeLog[i]:max;

				(max < csbi.dwSize.X)?(scale=1):(scale=(1.0*(csbi.dwSize.X-50))/max);

				for(i=0;i<MAXORDER;i++){
					printf("\nSize Order < 10^%2d bytes |",i);
					for(j=0;j<(int)(scale*fileSizeLog[i]);j++)
						printf("%c",219);
					printf("%Ld",fileSizeLog[i]);
				}
		}

	}
	return 0;
	}
}
