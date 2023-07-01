namespace RosettaCode
{
	class CSharpRecurringRainfall
    {		
		static int ReadNextInput()
		{
			System.Console.Write("Enter rainfall int, 99999 to quit: ");
			string input = System.Console.ReadLine();
			
			if (System.Int32.TryParse(input, out int num))
			{
				return num;
			}
			else
			{
				System.Console.WriteLine("Invalid input");
				return ReadNextInput();
			}
		}
		
        static void Main()
        {
			double currentAverage = 0;
			int currentEntryNumber = 0;
			
            for (int lastInput = ReadNextInput(); lastInput != 99999; lastInput = ReadNextInput())
            {
				currentEntryNumber++;
				currentAverage = currentAverage + (1.0/(float)currentEntryNumber)*lastInput - (1.0/(float)currentEntryNumber)*currentAverage;
				System.Console.WriteLine("New Average: " + currentAverage);
			}
        }
    }
}
