#include  <stdio.h>

int playerTurn(int numTokens, int take);
int computerTurn(int numTokens);

int main(void)
{
	printf("Nim Game\n\n");
	
	int Tokens = 12;
	
	while(Tokens > 0)
	{
		printf("How many tokens would you like to take?: ");
		
		int uin;
		scanf("%i", &uin);
		
		int nextTokens = playerTurn(Tokens, uin);
		
		if (nextTokens == Tokens)
		{
			continue;
		}
		
		Tokens = nextTokens;
		
		Tokens = computerTurn(Tokens);
	}
	printf("Computer wins.");
	
	return 0;
}

int playerTurn(int numTokens, int take)
{
	if (take < 1 || take > 3)
	{
		printf("\nTake must be between 1 and 3.\n\n");
		return numTokens;
	}
	int remainingTokens = numTokens - take;
	
	printf("\nPlayer takes %i tokens.\n", take);
	printf("%i tokens remaining.\n\n", remainingTokens);
	
	return remainingTokens;
}

int computerTurn(int numTokens)
{
	int take = numTokens % 4;
	int remainingTokens = numTokens - take;
	
	printf("Computer takes %u tokens.\n", take);
	printf("%i tokens remaining.\n\n", remainingTokens);
	
	return remainingTokens;
}
