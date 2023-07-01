class recurringrainfall
{
	private static int GetNextInt()
	{
		while (true)
		{
			System.out.print("Enter rainfall int, 99999 to quit: ");
			String input = System.console().readLine();

			try
			{
				int n = Integer.parseInt(input);
				return n;
			}
			catch (Exception e)
			{
				System.out.println("Invalid input");
			}
		}
	}
	
    private static void recurringRainfall() {
		float currentAverage = 0;
		int currentEntryNumber = 0;
		
		while (true) {
			int entry = GetNextInt();
			
			if (entry == 99999)
				return;
			
			currentEntryNumber++;
			currentAverage = currentAverage + ((float)1/currentEntryNumber)*entry - ((float)1/currentEntryNumber)*currentAverage;
			
			System.out.println("New Average: " + currentAverage);
		}
    }

    public static void main(String args[]) {
        recurringRainfall();
    }
}
