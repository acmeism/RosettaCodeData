#include<stdlib.h>
#include<stdio.h>
#include<math.h>

typedef struct{
	double x,y;
}point;

double lineSlope(point a,point b){
	
	if(a.x-b.x == 0.0)
		return NAN;
	else
		return (a.y-b.y)/(a.x-b.x);
}

point extractPoint(char* str){
	int i,j,start,end,length;
	char* holder;
	point c;
	
	for(i=0;str[i]!=00;i++){
		if(str[i]=='(')
			start = i;
		if(str[i]==','||str[i]==')')
		{
			end = i;
			
			length = end - start;
			
			holder = (char*)malloc(length*sizeof(char));
			
			for(j=0;j<length-1;j++)
				holder[j] = str[start + j + 1];
			holder[j] = 00;
			
			if(str[i]==','){
				start = i;
				c.x = atof(holder);
			}
			else
				c.y = atof(holder);
		}
	}
	
	return c;
}

point intersectionPoint(point a1,point a2,point b1,point b2){
	point c;
	
	double slopeA = lineSlope(a1,a2), slopeB = lineSlope(b1,b2);
	
	if(slopeA==slopeB){
		c.x = NAN;
		c.y = NAN;
	}
	else if(isnan(slopeA) && !isnan(slopeB)){
		c.x = a1.x;
		c.y = (a1.x-b1.x)*slopeB + b1.y;
	}
	else if(isnan(slopeB) && !isnan(slopeA)){
		c.x = b1.x;
		c.y = (b1.x-a1.x)*slopeA + a1.y;
	}
	else{
		c.x = (slopeA*a1.x - slopeB*b1.x + b1.y - a1.y)/(slopeA - slopeB);
		c.y = slopeB*(c.x - b1.x) + b1.y;
	}
	
	return c;
}

int main(int argC,char* argV[])
{
	point c;
	
	if(argC < 5)
		printf("Usage : %s <four points specified as (x,y) separated by a space>",argV[0]);
	else{
		c = intersectionPoint(extractPoint(argV[1]),extractPoint(argV[2]),extractPoint(argV[3]),extractPoint(argV[4]));
		
		if(isnan(c.x))
			printf("The lines do not intersect, they are either parallel or co-incident.");
		else
			printf("Point of intersection : (%lf,%lf)",c.x,c.y);
	}
	
	return 0;
}
