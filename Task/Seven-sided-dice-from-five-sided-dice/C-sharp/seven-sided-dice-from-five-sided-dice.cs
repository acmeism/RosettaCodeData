using System;

public class SevenSidedDice
{
    Random random = new Random();
		
        static void Main(string[] args)
		{
			SevenSidedDice sevenDice = new SevenSidedDice();
			Console.WriteLine("Random number from 1 to 7: "+ sevenDice.seven());
            Console.Read();
		}
		
		int seven()
		{
			int v=21;
			while(v>20)
				v=five()+five()*5-6;
			return 1+v%7;
		}
		
		int five()
		{
        return 1 + random.Next(5);
		}
}
