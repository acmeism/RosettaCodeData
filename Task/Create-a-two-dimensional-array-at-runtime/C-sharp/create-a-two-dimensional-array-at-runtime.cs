class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Enter two integers. Space delimited please: ");
            string s = Console.ReadLine();

            int[,] myArray=new int[(int)s[0],(int)s[2]];
            myArray[0, 0] = 2;
            Console.WriteLine(myArray[0, 0]);

            Console.ReadLine();
        }
    }
