#include<stdio.h>

typedef struct{
	double x,y,z;
}vector;

vector addVectors(vector a,vector b){
	return (vector){a.x+b.x,a.y+b.y,a.z+b.z};
}

vector subVectors(vector a,vector b){
	return (vector){a.x-b.x,a.y-b.y,a.z-b.z};
}

double dotProduct(vector a,vector b){
	return a.x*b.x + a.y*b.y + a.z*b.z;
}

vector scaleVector(double l,vector a){
	return (vector){l*a.x,l*a.y,l*a.z};
}

vector intersectionPoint(vector lineVector, vector linePoint, vector planeNormal, vector planePoint){
	vector diff = subVectors(linePoint,planePoint);
	
	return addVectors(addVectors(diff,planePoint),scaleVector(-dotProduct(diff,planeNormal)/dotProduct(lineVector,planeNormal),lineVector));
}

int main(int argC,char* argV[])
{
	vector lV,lP,pN,pP,iP;
	
	if(argC!=5)
		printf("Usage : %s <line direction, point on line, normal to plane and point on plane given as (x,y,z) tuples separated by space>");
	else{
		sscanf(argV[1],"(%lf,%lf,%lf)",&lV.x,&lV.y,&lV.z);
		sscanf(argV[3],"(%lf,%lf,%lf)",&pN.x,&pN.y,&pN.z);
		
		if(dotProduct(lV,pN)==0)
			printf("Line and Plane do not intersect, either parallel or line is on the plane");
		else{
			sscanf(argV[2],"(%lf,%lf,%lf)",&lP.x,&lP.y,&lP.z);
			sscanf(argV[4],"(%lf,%lf,%lf)",&pP.x,&pP.y,&pP.z);
			
			iP = intersectionPoint(lV,lP,pN,pP);
			
			printf("Intersection point is (%lf,%lf,%lf)",iP.x,iP.y,iP.z);
		}
	}
		
	return 0;
}
