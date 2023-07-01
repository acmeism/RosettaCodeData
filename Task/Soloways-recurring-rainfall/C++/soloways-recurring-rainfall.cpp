#include <iostream>
#include <limits>

int main()
{
	float currentAverage = 0;
	unsigned int currentEntryNumber = 0;
	
	for (;;)
	{
		int entry;
		
		std::cout << "Enter rainfall int, 99999 to quit: ";
		std::cin >> entry;
		
		if (!std::cin.fail())
		{
			if (entry == 99999)
			{
				std::cout << "User requested quit." << std::endl;
				break;
			}
			else
			{
				currentEntryNumber++;
				currentAverage = currentAverage + (1.0f/currentEntryNumber)*entry - (1.0f/currentEntryNumber)*currentAverage;
				
				std::cout << "New Average: " << currentAverage << std::endl;
			}
		}
		else
		{
			std::cout << "Invalid input" << std::endl;
			std::cin.clear();
			std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
		}
	}
	
	return 0;
}
