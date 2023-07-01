#include<stdio.h>

int main()
{
	int num = 9876432,diff[] = {4,2,2,2},i,j,k=0;
	char str[10];
	
		start:snprintf(str,10,"%d",num);

		for(i=0;str[i+1]!=00;i++){
			if(str[i]=='0'||str[i]=='5'||num%(str[i]-'0')!=0){
				num -= diff[k];
				k = (k+1)%4;
				goto start;
			}
			for(j=i+1;str[j]!=00;j++)
				if(str[i]==str[j]){
					num -= diff[k];
					k = (k+1)%4;
					goto start;
			}
		}	
	
	printf("Number found : %d",num);
	return 0;
}
