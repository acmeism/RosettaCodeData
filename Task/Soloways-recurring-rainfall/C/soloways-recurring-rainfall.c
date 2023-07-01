#include <stdio.h>

int main(int argc, char **argv)
{
	// Unused variables
	(void)argc;
	(void)argv;
	
	float currentAverage = 0;
	unsigned int currentEntryNumber = 0;
	
	for (;;)
	{
		int ret, entry;
		
		printf("Enter rainfall int, 99999 to quit: ");
		ret = scanf("%d", &entry);
		
		if (ret)
		{
			if (entry == 99999)
			{
				printf("User requested quit.\n");
				break;
			}
			else
			{
				currentEntryNumber++;
				currentAverage = currentAverage + (1.0f/currentEntryNumber)*entry - (1.0f/currentEntryNumber)*currentAverage;
				
				printf("New Average: %f\n", currentAverage);
			}
		}
		else
		{
			printf("Invalid input\n");
			while (getchar() != '\n');	// Clear input buffer before asking again
		}
	}
	
	return 0;
}
