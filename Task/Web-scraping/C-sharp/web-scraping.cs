class Program
    {
        static void Main(string[] args)
        {
            WebClient wc = new WebClient();
            Stream myStream = wc.OpenRead("http://tycho.usno.navy.mil/cgi-bin/timer.pl");
            string html = "";
            using (StreamReader sr = new StreamReader(myStream))
            {
                while (sr.Peek() >= 0)
                {
                    html = sr.ReadLine();
                    if (html.Contains("UTC"))
                    {
                        break;
                    }
                }

            }
            Console.WriteLine(html.Remove(0, 4));

            Console.ReadLine();
        }
    }
