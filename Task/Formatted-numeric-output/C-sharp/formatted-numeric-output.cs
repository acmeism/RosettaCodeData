class Program
    {


        static void Main(string[] args)
        {

            float myNumbers = 7.125F;

            string strnumber = Convert.ToString(myNumbers);

            Console.WriteLine(strnumber.PadLeft(9, '0'));

            Console.ReadLine();
        }




    }
