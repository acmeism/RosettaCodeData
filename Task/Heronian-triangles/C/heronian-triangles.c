#include<stdlib.h>
#include<stdio.h>
#include<math.h>

typedef struct{
	int a,b,c;
	int perimeter;
	double area;
}triangle;

typedef struct elem{
	triangle t;
	struct elem* next;
}cell;

typedef cell* list;

void addAndOrderList(list *a,triangle t){
	list iter,temp;
	int flag = 0;
	
	if(*a==NULL){
		*a = (list)malloc(sizeof(cell));
		(*a)->t = t;
		(*a)->next = NULL;
	}
	
	else{
		temp = (list)malloc(sizeof(cell));

			iter = *a;
			while(iter->next!=NULL){
				if(((iter->t.area<t.area)||(iter->t.area==t.area && iter->t.perimeter<t.perimeter)||(iter->t.area==t.area && iter->t.perimeter==t.perimeter && iter->t.a<=t.a))
				&&
				(iter->next==NULL||(t.area<iter->next->t.area || t.perimeter<iter->next->t.perimeter || t.a<iter->next->t.a))){
					temp->t = t;
					temp->next = iter->next;
					iter->next = temp;
					flag = 1;
					break;
				}

				iter = iter->next;
			}
			
			if(flag!=1){
				temp->t = t;
				temp->next = NULL;
				iter->next = temp;
			}
	}
}

int gcd(int a,int b){
	if(b!=0)
		return gcd(b,a%b);
	return a;
}

void calculateArea(triangle *t){
	(*t).perimeter = (*t).a + (*t).b + (*t).c;
	(*t).area = sqrt(0.5*(*t).perimeter*(0.5*(*t).perimeter - (*t).a)*(0.5*(*t).perimeter - (*t).b)*(0.5*(*t).perimeter - (*t).c));
}

list generateTriangleList(int maxSide,int *count){
	int a,b,c;
	triangle t;
	list herons = NULL;
	
	*count = 0;
	
	for(a=1;a<=maxSide;a++){
		for(b=1;b<=a;b++){
			for(c=1;c<=b;c++){
				if(c+b > a && gcd(gcd(a,b),c)==1){
					t = (triangle){a,b,c};
					calculateArea(&t);
					if(t.area/(int)t.area == 1){
						addAndOrderList(&herons,t);
						(*count)++;
					}	
				}
			}
		}
	}
	
	return herons;
}

void printList(list a,int limit,int area){
	list iter = a;
	int count = 1;
	
	printf("\nDimensions\tPerimeter\tArea");
	
	while(iter!=NULL && count!=limit+1){
		if(area==-1 ||(area==iter->t.area)){
			printf("\n%d x %d x %d\t%d\t\t%d",iter->t.a,iter->t.b,iter->t.c,iter->t.perimeter,(int)iter->t.area);
			count++;
		}
		iter = iter->next;
	}
}

int main(int argC,char* argV[])
{
	int count;
	list herons = NULL;
	
	if(argC!=4)
		printf("Usage : %s <Max side, max triangles to print and area, -1 for area to ignore>",argV[0]);
	else{
		herons = generateTriangleList(atoi(argV[1]),&count);
		printf("Triangles found : %d",count);
		(atoi(argV[3])==-1)?printf("\nPrinting first %s triangles.",argV[2]):printf("\nPrinting triangles with area %s square units.",argV[3]);
		printList(herons,atoi(argV[2]),atoi(argV[3]));
		free(herons);
	}
	return 0;
}
