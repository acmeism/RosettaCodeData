using System;
using System.IO;
using System.Collections.Generic;

class Program
{
    static void Main()
    {
        Console.Clear();
        Console.WriteLine("Input a number of doors to calculate, then press enter");
        StartCalculator();
    }

    static void StartCalculator()
    {
        //The number to calculate is input here
        string input = Console.ReadLine();
        Console.Clear();

        try
        {
            //The program attempts to convert the string to an int
            //Exceptions will be caught on this line
            int numberOfDoors = Convert.ToInt32(input);

            //Will call method recursively if input number is less than 1
            if (numberOfDoors <= 0)
            {
                Console.WriteLine("Please use a number greater than 0");
                StartCalculator();
            }

            //The program then starts the calculation process
            Calculate(numberOfDoors);

            //After calculation process is finished, restart method is called
            RestartCalculator();
        }
        catch(FormatException)
        {
            //Code will be executed if the number has a decimal or has an unrecognizable symbol
            Console.WriteLine("Unable to read. Please use a real number without a decimal");
            StartCalculator();
        }
        catch (OverflowException)
        {
            //Code will be executed if number is too long
            Console.WriteLine("You number is too long");
            StartCalculator();
        }
    }

    static void Calculate(int numberOfDoors)
    {
        //Increases numberOfDoors by 1 since array starts at 0
        numberOfDoors++;

        //Dictionary key represents door number, value represents if the door is open
        //if value == true, the door is open
        Dictionary<int, bool> doors = new Dictionary<int, bool>();

        //Creates Dictionary size of numberOfDoors, all initialized at false
        for(int i = 0; i < numberOfDoors; i++)
        {
            doors.Add(i, false);
        }

        //Creates interval between doors, starting at 0, while less than numberOfDoors
        for (int doorInterval = 0; doorInterval < numberOfDoors; doorInterval++)
        {
            //Will alter every cubby at doorInterval
            //1 needs to be added since doorInterval will start at 0 and end when equal to numberOfDoors
            for(int i = 0; i < numberOfDoors; i += doorInterval + 1)
            {
                //Changes a false value to true and vice versa
                doors[i] = doors[i] ? false: true;
            }
        }

        //Writes each door and whether it is open or closed
        for(int i = 0; i < numberOfDoors; i++)
        {
            //Skips over door 0
            if (i == 0) continue;
            //Writes open if door value is true, writes closed if door value is false
            Console.WriteLine("Door " + (i) + " is " + (doors[i] ? "open" : "closed"));
        }
    }

    static void RestartCalculator()
    {
        Console.WriteLine("Press any key to restart");
        Console.ReadKey(true);
        Main();
    }
}
