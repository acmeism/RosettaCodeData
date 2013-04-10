 using System;
class Program
{
 static void Main(string[] args)
        {
            bool[] Doors = new bool[101];


            //Close all doors to start
            for (int g=1;g<101;g++) Doors[g] = false;

            for (int i = 1; i < 101; i++)//number of passes
            {
                for (int d = 1; d < 101; d++)//door number
                {
                    if ((d % i) == 0)
                    {
                        if (Doors[d]) Doors[d] = false;
                        else Doors[d] = true;
                    }

                }
            }

            Console.WriteLine("Passes Completed!!!  Here are the results: \r\n");
            for (int p = 1; p < 101; p++)
            {
                if (Doors[p])
                {
                    string doorStatus = String.Format("Door #{0} is \'OPENED\'.", p.ToString());
                    Console.WriteLine(doorStatus);
                }
                else
                {
                    string doorStatus = String.Format("Door #{0} is \'CLOSED\'.", p.ToString());
                    Console.WriteLine(doorStatus);
                 }

            }
        }
}
