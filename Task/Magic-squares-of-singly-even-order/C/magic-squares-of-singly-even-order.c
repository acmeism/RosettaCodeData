   #include<stdlib.h>
   #include<ctype.h>
   #include<stdio.h>

   int** oddMagicSquare(int n) {
        if (n < 3 || n % 2 == 0)
            return NULL;

        int value = 0;
        int squareSize = n * n;
        int c = n / 2, r = 0,i;

        int** result = (int**)malloc(n*sizeof(int*));
		
		for(i=0;i<n;i++)
			result[i] = (int*)malloc(n*sizeof(int));

        while (++value <= squareSize) {
            result[r][c] = value;
            if (r == 0) {
                if (c == n - 1) {
                    r++;
                } else {
                    r = n - 1;
                    c++;
                }
            } else if (c == n - 1) {
                r--;
                c = 0;
            } else if (result[r - 1][c + 1] == 0) {
                r--;
                c++;
            } else {
                r++;
            }
        }
        return result;
    }

    int** singlyEvenMagicSquare(int n) {
        if (n < 6 || (n - 2) % 4 != 0)
            return NULL;

        int size = n * n;
        int halfN = n / 2;
        int subGridSize = size / 4, i;

        int** subGrid = oddMagicSquare(halfN);
        int gridFactors[] = {0, 2, 3, 1};
        int** result = (int**)malloc(n*sizeof(int*));
		
		for(i=0;i<n;i++)
			result[i] = (int*)malloc(n*sizeof(int));

        for (int r = 0; r < n; r++) {
            for (int c = 0; c < n; c++) {
                int grid = (r / halfN) * 2 + (c / halfN);
                result[r][c] = subGrid[r % halfN][c % halfN];
                result[r][c] += gridFactors[grid] * subGridSize;
            }
        }

        int nColsLeft = halfN / 2;
        int nColsRight = nColsLeft - 1;

        for (int r = 0; r < halfN; r++)
            for (int c = 0; c < n; c++) {
                if (c < nColsLeft || c >= n - nColsRight
                        || (c == nColsLeft && r == nColsLeft)) {

                    if (c == 0 && r == nColsLeft)
                        continue;

                    int tmp = result[r][c];
                    result[r][c] = result[r + halfN][c];
                    result[r + halfN][c] = tmp;
                }
            }

        return result;
    }
	
	int numDigits(int n){
		int count = 1;
		
		while(n>=10){
			n /= 10;
			count++;
		}
		
		return count;
	}
	
	void printMagicSquare(int** square,int rows){
		int i,j;
		
		for(i=0;i<rows;i++){
			for(j=0;j<rows;j++){
				printf("%*s%d",rows - numDigits(square[i][j]),"",square[i][j]);
			}
			printf("\n");
		}
		printf("\nMagic constant: %d ", (rows * rows + 1) * rows / 2);
	}
	
	int main(int argC,char* argV[])
	{
		int n;
		
		if(argC!=2||isdigit(argV[1][0])==0)
			printf("Usage : %s <integer specifying rows in magic square>",argV[0]);
		else{
			n = atoi(argV[1]);
			printMagicSquare(singlyEvenMagicSquare(n),n);
		}
		return 0;
	}
