/*Abhishek Ghosh, 5th October 2017*/

#include<string.h>
#include<stdlib.h>
#include<locale.h>
#include<stdio.h>
#include<wchar.h>
#include<math.h>

int main(int argC,char* argV[])
{
	double* arr,min,max;
	char* str;
	int i,len;
	if(argC == 1)
		printf("Usage : %s <data points separated by spaces or commas>",argV[0]);
	else{
		arr = (double*)malloc((argC-1)*sizeof(double));
		for(i=1;i<argC;i++){
			len = strlen(argV[i]);
			
			if(argV[i][len-1]==','){
				str = (char*)malloc(len*sizeof(char));
				strncpy(str,argV[i],len-1);
				arr[i-1] = atof(str);
				free(str);
			}
			else
				arr[i-1] = atof(argV[i]);
			if(i==1){
				min = arr[i-1];
				max = arr[i-1];
			}
			else{
				min=(min<arr[i-1]?min:arr[i-1]);
				max=(max>arr[i-1]?max:arr[i-1]);
			}
		}
		
		printf("\n%Max : %lf,Min : %lf,Range : %lf\n",max,min,max-min);
		
		setlocale(LC_ALL, "");
		
		for(i=1;i<argC;i++){
			printf("%lc", (wint_t)(9601 + (int)ceil((arr[i-1]-min)/(max-min)*7)));
		}
	}
	return 0;
}
