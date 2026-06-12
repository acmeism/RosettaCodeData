#include <stdio.h>
#include <stdlib.h>

int main(){	
	int temp;
	int numbers=3;
	int a[numbers+1], upto = 4, temp2;
	for( temp2 = 1 ; temp2 <= numbers; temp2++){
		a[temp2]=1;
	}
	a[numbers]=0;
	temp=numbers;
	while(1){
		if(a[temp]==upto){
			temp--;
			if(temp==0)
				break;
		}
		else{
			a[temp]++;
			while(temp<numbers){
				temp++;
				a[temp]=1;
			}
			
			printf("(");
			for( temp2 = 1 ; temp2 <= numbers; temp2++){
				printf("%d", a[temp2]);
			}
			printf(")");
		}
	}
	return 0;
}
