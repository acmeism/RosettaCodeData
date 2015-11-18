#include <iostream>
#include <algorithm>
#include<cstdio>
using namespace std;
void Pascal_Triangle(int size) {

	int a[100][100];
	int i, j;

	//first row and first coloumn has the same value=1
	for (i = 1; i <= size; i++) {
		a[i][1] = a[1][i] = 1;
	}
	
	//Generate the full Triangle
	for (i = 2; i <= size; i++) {
		for (j = 2; j <= size - i; j++) {
			if (a[i - 1][j] == 0 || a[i][j - 1] == 0) {
				break;
			}
			a[i][j] = a[i - 1][j] + a[i][j - 1];
		}
	}

	/*
	  1 1 1 1
	  1 2 3
	  1 3
	  1
	
	first print as above format-->
	
	for (i = 1; i < size; i++) {
		for (j = 1; j < size; j++) {
			if (a[i][j] == 0) {
					break;
			}
				printf("%8d",a[i][j]);
		}
			cout<<"\n\n";
	}*/
	
	// standard Pascal Triangle Format
	
	int row,space;
	for (i = 1; i < size; i++) {
		space=row=i;
		j=1;
		
		while(space<=size+(size-i)+1){
			 cout<<" ";
			 space++;
		 }
		
		while(j<=i){
			if (a[row][j] == 0){
				   break;
			   }
			
			if(j==1){
				printf("%d",a[row--][j++]);
			}
			else
				printf("%6d",a[row--][j++]);
		}
			cout<<"\n\n";
	}
	
}

int main()
{
	//freopen("out.txt","w",stdout);
	
	int size;
	cin>>size;
	Pascal_Triangle(size);
}

}
