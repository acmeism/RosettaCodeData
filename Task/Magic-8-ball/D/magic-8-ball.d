import std.random, std.stdio, std.string;

const string[] responses = ["It is certain", "It is decidedly so",
                            "Without a doubt", "Yes, definitely",
                            "You may rely on it", "As I see it, yes",
                            "Most likely", "Outlook good", "Signs point to yes",
                            "Yes", "Reply hazy, try again", "Ask again later",
                            "Better not tell you now", "Cannot predict now",
                            "Concentrate and ask again", "Don't bet on it",
                            "My reply is no", "My sources say no",
                            "Outlook not so good", "Very doubtful"];

void main()
{
    string question = "";
    auto rnd = Random(unpredictableSeed);
    int index = -1;

    writeln("Welcome to 8 ball! Please enter your question to ");
    write("find the answers you seek.");
    write("Type 'quit' to exit.", "\n\n");

    while(true)
    {
        write("Question: ");
        question = stdin.readln();
        if(strip(question) == "quit")
        {
            break;
        }
        write("Response: ");
        index = uniform(0, 20, rnd);
        write(responses[index], "\n\n");
    }
}
