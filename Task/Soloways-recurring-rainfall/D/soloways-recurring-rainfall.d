import std.stdio;

void main()
{
	float currentAverage = 0;
	uint currentEntryNumber = 0;
	
	for (;;)
	{
		int entry;
				
		write("Enter rainfall int, 99999 to quit: ");
		
		try {
			readf("%d", entry);
			readln();
		}
		catch (Exception e) {
			writeln("Invalid input");
			readln();
			continue;
		}
		
		if (entry == 99999) {
			writeln("User requested quit.");
			break;
		} else {
			currentEntryNumber++;
			currentAverage = currentAverage + (1.0/currentEntryNumber)*entry - (1.0/currentEntryNumber)*currentAverage;
			
			writeln("New Average: ", currentAverage);
		}
	}
}
