#include<stdlib.h>
#include<stdio.h>

/*The stdlib header file is required for the malloc and free functions*/

int main()
{
	/*Declaring a four fold integer pointer, also called
	a pointer to a pointer to a pointer to an integer pointer*/
	
	int**** hyperCube, i,j,k;

	/*We will need i,j,k for the memory allocation*/
	
	/*First the five lines*/
	
	hyperCube = (int****)malloc(5*sizeof(int***));
	
	/*Now the four planes*/
	
	for(i=0;i<5;i++){
		hyperCube[i] = (int***)malloc(4*sizeof(int**));
		
		/*Now the 3 cubes*/
		
		for(j=0;j<4;j++){
			hyperCube[i][j] = (int**)malloc(3*sizeof(int*));
			
			/*Now the 2 hypercubes (?)*/
			
			for(k=0;k<3;k++){
				hyperCube[i][j][k] = (int*)malloc(2*sizeof(int));
			}
		}
	}
	
	/*All that looping and function calls may seem futile now,
	but imagine real applications when the dimensions of the dataset are
	not known beforehand*/
	
	/*Yes, I just copied the rest from the first program*/
	
	hyperCube[4][3][2][1] = 1;
	
	/*IMPORTANT : C ( and hence C++ and Java and everyone of the family ) arrays are zero based.
	The above element is thus actually the last element of the hypercube.*/
	
	/*Now we print out that element*/
	
	printf("\n%d",hyperCube[4][3][2][1]);
	
	/*But that's not the only way to get at that element*/
	printf("\n%d",*(*(*(*(hyperCube + 4) + 3) + 2) + 1));

	/*Yes, I know, it's beautiful*/
	*(*(*(*(hyperCube+3)+2)+1)) = 3;
	
	printf("\n%d",hyperCube[3][2][1][0]);
	
	/*Always nice to clean up after you, yes memory is cheap, but C is 45+ years old,
	and anyways, imagine you are dealing with terabytes of data, or more...*/
	
	free(hyperCube);
	
	return 0;
}
