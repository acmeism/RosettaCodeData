        static void Main(string[] args)
        {
            List<string> menu_items = new List<string>() { "fee fie", "huff and puff", "mirror mirror", "tick tock" };
            //List<string> menu_items = new List<string>();
            Console.WriteLine(PrintMenu(menu_items));
            Console.ReadLine();
        }
        private static string PrintMenu(List<string> items)
        {
            if (items.Count == 0)
                return "";

            string input = "";
            int i = -1;
            do
            {
                for (int j = 0; j < items.Count; j++)
                    Console.WriteLine("{0}) {1}", j, items[j]);

                Console.WriteLine("What number?");
                input = Console.ReadLine();

            } while (!int.TryParse(input, out i) || i >= items.Count || i < 0);
            return items[i];
        }
