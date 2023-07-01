#include<stdio.h>

int main()
{
	int hyperCube[5][4][3][2];
	
	/*An element is set*/
	
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
	
	return 0;
}
