using System;

class Program
{
    static void Main(string[] args)
    {
        int switchWins = 0;
        int stayWins = 0;

        Random gen = new Random();
		
        for(int plays = 0; plays < 1000000; plays++ )
        {
            int[] doors = {0,0,0};//0 is a goat, 1 is a car

            var winner = gen.Next(3);
            doors[winner] = 1; //put a winner in a random door

	    int choice = gen.Next(3); //pick a door, any door
	    int shown; //the shown door
	    do
            {
	        shown = gen.Next(3);
	    }
            while (doors[shown] == 1 || shown == choice); //don't show the winner or the choice

	    stayWins += doors[choice]; //if you won by staying, count it

            //the switched (last remaining) door is (3 - choice - shown), because 0+1+2=3
            switchWins += doors[3 - choice - shown];
        }

        Console.Out.WriteLine("Staying wins " + stayWins + " times.");
        Console.Out.WriteLine("Switching wins " + switchWins + " times.");
    }
}
