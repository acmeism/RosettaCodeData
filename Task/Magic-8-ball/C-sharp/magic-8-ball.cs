using System;

namespace newProg
{

    class Program
    {
        static void Main(string[] args)
        {
            string[] answers =
            {
                "It is certain.",
                "It is decidedly so.",
                "Without a doubt.",
                "Yes – definitely.",
                "You may rely on it.",
                "As I see it, yes.",
                "Most likely.",
                "Outlook good.",
                "Yes.",
                "Signs point to yes.",
                "Reply hazy, try again.",
                "Ask again later",
                "Better not tell you now.",
                "Cannot predict now.",
                "Concentrate and ask again.",
                "Don't count on it.",
                "My reply is no.",
                "My sources say no.",
                "Outlook not so good.",
                "Very doubtful."
            };

            while (true)
            {
                Random rnd = new Random();
                int result = rnd.Next(0, 19);

                Console.WriteLine("Magic 8 Ball! Ask question and hit a key for the answer!");

                string inp = Console.ReadLine();

                Console.WriteLine(answers[result]);

            }
        }
    }
}
