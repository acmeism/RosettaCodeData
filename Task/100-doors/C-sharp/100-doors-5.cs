    class Program
    {
        static void Main(string[] args)
        {
            bool[] doorStates = new bool[100];
            int n = 0;
            int d;
            while ((d = (++n * n)) <= 100)
                doorStates[d - 1] = true;
            for (int i = 0; i < doorStates.Length; i++)
                Console.WriteLine("Door {0}: {1}", i + 1, doorStates[i] ? "Open" : "Closed");
            Console.ReadKey(true);
        }
    }
