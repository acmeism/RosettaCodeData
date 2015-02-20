#include <stdio.h>
#include <stdlib.h>

int i, j;

void fliprow(int **b, int sz, int n)
{
	for(i = 0; i < sz; i++)
		b[n+1][i] = !b[n+1][i];
}

void flipcol(int **b, int sz, int n)
{
	for(i = 1; i <= sz; i++)
		b[i][n] = !b[i][n];
}

void initt(int **t, int sz)
{
	for(i = 1; i <= sz; i++)
		for(j = 0; j < sz; j++)
			t[i][j] = rand()%2;
}

void initb(int **t, int **b, int sz)
{
	for(i = 1; i <= sz; i++)
		for(j = 0; j < sz; j++)
			b[i][j] = t[i][j];
	
	for(i = 1; i <= sz; i++)
		fliprow(b, sz, rand()%sz+1);
	for(i = 0; i < sz; i++)
		flipcol(b, sz, rand()%sz);
}

void printb(int **b, int sz)
{
	printf(" ");
	for(i = 0; i < sz; i++)
		printf(" %d", i);
	printf("\n");

	for(i = 1; i <= sz; i++)
	{
		printf("%d", i-1);
		for(j = 0; j < sz; j++)
			printf(" %d", b[i][j]);
		printf("\n");
	}
	
	printf("\n");
}

int eq(int **t, int **b, int sz)
{
	for(i = 1; i <= sz; i++)
		for(j = 0; j < sz; j++)
			if(b[i][j] != t[i][j])
				return 0;
	return 1;
}

void main()
{
	int sz = 3;
	int eql = 0;
	int mov = 0;
	int **t = malloc(sz*(sizeof(int)+1));
	for(i = 1; i <= sz; i++)
		t[i] = malloc(sz*sizeof(int));

	int **b = malloc(sz*(sizeof(int)+1));
	for(i = 1; i <= sz; i++)
		b[i] = malloc(sz*sizeof(int));
	char roc;
	int n;
	initt(t, sz);
	initb(t, b, sz);
	
	while(eq(t, b, sz))
		initb(t, b, sz);
	
	while(!eql)
	{
		printf("Target: \n");
		printb(t, sz);
		printf("Board: \n");
		printb(b, sz);
		printf("What to flip: ");
		scanf(" %c", &roc);
		scanf(" %d", &n);

		switch(roc)
		{
			case 'r':
				fliprow(b, sz, n);
				break;
			case 'c':
				flipcol(b, sz, n);
				break;
			default:
				perror("Please specify r or c and an number");
				break;
		}

		printf("Moves Taken: %d\n", ++mov);

		if(eq(t, b, sz))
		{
			printf("You win!\n");
			eql = 1;
		}
	}
}
