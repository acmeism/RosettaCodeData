/*
The following code generates the permutations of the first 4 natural numbers.
The permutations are displayed in lexical order, smallest to largest, with appropriate signs
*/

#include <iostream>
#include <conio.h>

//factorial function
long
fact(int size)
{
	int i;
	long tmp = 1;

	if(size<=1)
		return 1;
	else
		for(i = size;i > 0;i--)
			tmp *= i;
	return tmp;
}


//function to display the permutations.
void
Permutations(int N)
{
	//indicates sign
	short sign = 1;

	//Tracks when to change sign.
	unsigned short change_sign = 0;

	//loop variables
	short i = 0,j = 0,k = 0;

	//iterations
	long loops = fact(N);

	//Array of pointers to hold the digits
	int **Index_Nos_ptr = new int*[N];

	//Repetition of each digit (Master copy)
	int *Digit_Rep_Master = new int[N];

	//Repetition of each digit (Local copy)
	int *Digit_Rep_Local = new int[N];

	//Index for Index_Nos_ptr
	int *Element_Num = new int[N];


	//Initialization
	for(i = 0;i < N;i++){
		//Allocate memory to hold the subsequent digits in the form of a LUT
	            //For N = N, memory required for LUT = N(N+1)/2
		Index_Nos_ptr[i] = new int[N-i];

		//Initialise the repetition value of each digit (Master and Local)
		//Each digit repeats for (i-1)!, where 1 is the position of the digit
		Digit_Rep_Local[i] = Digit_Rep_Master[i] = fact(N-i-1);

		//Initialise index values to access the arrays
		Element_Num[i] = N-i-1;

		//Initialise the arrays with the required digits
		for(j = 0;j < N-i;j++)
			*(Index_Nos_ptr[i] +j) = N-j-1;
	}

	while(loops-- > 0){
		std::cout << "Perm: [";
		for(i = 0;i < N;i++){
			//Print from MSD to LSD
			std::cout << " " << *(Index_Nos_ptr[i] + Element_Num[i]);

			//Decrement the repetition count for each digit
			if(--Digit_Rep_Local[i] <= 0){
				//Refill the repitition factor
				Digit_Rep_Local[i] = Digit_Rep_Master[i];

				//And the index to access the required digit is also 0...
				if(Element_Num[i] <= 0 && i != 0){
					//Reset the index
					Element_Num[i] = N-i-1;

					//Update the numbers held in Index_Nos_ptr[]
					for(j = 0,k = 0;j <= N-i;j++){
						//Exclude the preceeding digit (from the previous array) already printed.
						if(j != Element_Num[i-1]){
							*(Index_Nos_ptr[i]+k)= *(Index_Nos_ptr[i-1]+j);
							k++;
						}
					}
				}else
					//Decrement the index value so as to print the appropriate digit
					//in the same array
					Element_Num[i]--;
			}
		}
		std::cout<<"]  Sign: "<< sign <<"\n";

		if(!(change_sign-- > 0)){
			//Update the sign value.
			sign = -sign;

			change_sign = 1;
		}

	}

}

int
main()
{
	Permutations(4);
	getch();
	return 0;
}
