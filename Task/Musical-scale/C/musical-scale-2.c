#include<windows.h>
#include<stdio.h>
#include<math.h>

typedef struct{
	char str[3];
	int key;
	}note;
	
note sequence[] = {{"Do",0},{"Re",2},{"Mi",4},{"Fa",5},{"So",7},{"La",9},{"Ti",11},{"Do",12}};

int main(void)
{
	int i=0;
	
	while(1)
	{
		printf("\t%s",sequence[i].str);
		Beep(261.63*pow(2,sequence[i].key/12.0),sequence[i].key%12==0?500:1000);
		i = (i+1)%8;
		i==0?printf("\n"):printf("");
	}
	return 0;
}
