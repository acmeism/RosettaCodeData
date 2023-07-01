#include<stdlib.h>
#include<stdio.h>

typedef struct{
	char str[30];
}item;

item* makeList(char* separator){
	int counter = 0,i;
	item* list = (item*)malloc(3*sizeof(item));
	
	item makeItem(){
		item holder;
		
		char names[5][10] = {"first","second","third","fourth","fifth"};
		
		sprintf(holder.str,"%d%s%s",++counter,separator,names[counter]);
		
		return holder;
	}
	
	for(i=0;i<3;i++)
		list[i] = makeItem();
	
	return list;
}

int main()
{
	int i;
	item* list = makeList(". ");
	
	for(i=0;i<3;i++)
		printf("\n%s",list[i].str);
	
	return 0;
}
