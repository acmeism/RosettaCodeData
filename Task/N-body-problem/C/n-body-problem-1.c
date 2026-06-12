#include<stdlib.h>
#include<stdio.h>
#include<math.h>

typedef struct{
	double x,y,z;
}vector;

int bodies,timeSteps;
double *masses,GravConstant;
vector *positions,*velocities,*accelerations;

vector addVectors(vector a,vector b){
	vector c = {a.x+b.x,a.y+b.y,a.z+b.z};
	
	return c;
}

vector scaleVector(double b,vector a){
	vector c = {b*a.x,b*a.y,b*a.z};
	
	return c;
}

vector subtractVectors(vector a,vector b){
	vector c = {a.x-b.x,a.y-b.y,a.z-b.z};
	
	return c;
}

double mod(vector a){
	return sqrt(a.x*a.x + a.y*a.y + a.z*a.z);
}

void initiateSystem(char* fileName){
	int i;
	FILE* fp = fopen(fileName,"r");
	
	fscanf(fp,"%lf%d%d",&GravConstant,&bodies,&timeSteps);

	masses = (double*)malloc(bodies*sizeof(double));
	positions = (vector*)malloc(bodies*sizeof(vector));
	velocities = (vector*)malloc(bodies*sizeof(vector));
	accelerations = (vector*)malloc(bodies*sizeof(vector));
	
	for(i=0;i<bodies;i++){
		fscanf(fp,"%lf",&masses[i]);
		fscanf(fp,"%lf%lf%lf",&positions[i].x,&positions[i].y,&positions[i].z);
		fscanf(fp,"%lf%lf%lf",&velocities[i].x,&velocities[i].y,&velocities[i].z);
	}
	
	fclose(fp);
}

void resolveCollisions(){
	int i,j;
	
	for(i=0;i<bodies-1;i++)
		for(j=i+1;j<bodies;j++){
			if(positions[i].x==positions[j].x && positions[i].y==positions[j].y && positions[i].z==positions[j].z){
				vector temp = velocities[i];
				velocities[i] = velocities[j];
				velocities[j] = temp;
			}
		}
}

void computeAccelerations(){
	int i,j;
	
	for(i=0;i<bodies;i++){
		accelerations[i].x = 0;
		accelerations[i].y = 0;
		accelerations[i].z = 0;
		for(j=0;j<bodies;j++){
			if(i!=j){
				accelerations[i] = addVectors(accelerations[i],scaleVector(GravConstant*masses[j]/pow(mod(subtractVectors(positions[i],positions[j])),3),subtractVectors(positions[j],positions[i])));
			}
		}
	}
}

void computeVelocities(){
	int i;
	
	for(i=0;i<bodies;i++)
		velocities[i] = addVectors(velocities[i],accelerations[i]);
}

void computePositions(){
	int i;
	
	for(i=0;i<bodies;i++)
		positions[i] = addVectors(positions[i],addVectors(velocities[i],scaleVector(0.5,accelerations[i])));
}

void simulate(){
	computeAccelerations();
	computePositions();
	computeVelocities();
	resolveCollisions();
}

int main(int argC,char* argV[])
{
	int i,j;
	
	if(argC!=2)
		printf("Usage : %s <file name containing system configuration data>",argV[0]);
	else{
		initiateSystem(argV[1]);
		printf("Body   :     x              y               z           |           vx              vy              vz   ");
		for(i=0;i<timeSteps;i++){
			printf("\nCycle %d\n",i+1);
			simulate();
			for(j=0;j<bodies;j++)
				printf("Body %d : %lf\t%f\t%lf\t|\t%lf\t%lf\t%lf\n",j+1,positions[j].x,positions[j].y,positions[j].z,velocities[j].x,velocities[j].y,velocities[j].z);
		}
	}
	return 0;
}
