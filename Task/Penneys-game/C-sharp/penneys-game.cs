using static System.Console;
using static System.Threading.Thread;
using System;

public static class PenneysGame
{
    const int pause = 500;
    const int N = 3;
    static Random rng = new Random();

    static int Toss() => rng.Next(2);

    static string AsString(this int sequence) {
        string s = "";
        for (int b = 0b100; b > 0; b >>= 1) {
            s += (sequence & b) > 0 ? 'T' : 'H';
        }
        return s;
    }

    static int UserInput() {
        while (true) {
            switch (ReadKey().Key) {
                case ConsoleKey.Escape: return -1;
                case ConsoleKey.H: return 0;
                case ConsoleKey.T: return 1;
            }
            Console.Write('\b');
        }
    }

    public static void Main2() {
        int yourScore = 0, myScore = 0;
        while (true) {
            WriteLine($"Your score: {yourScore}, My score: {myScore}");
            WriteLine("Determining who goes first...");
            Sleep(pause);
            bool youStart = Toss() == 1;
            WriteLine(youStart ? "You go first." : "I go first.");
            int yourSequence = 0, mySequence = 0;
            if (youStart) {
                WriteLine("Choose your sequence of (H)eads and (T)ails (or press Esc to exit)");
                int userChoice;
                for (int i = 0; i < N; i++) {
                    if ((userChoice = UserInput()) < 0) return;
                    yourSequence = (yourSequence << 1) + userChoice;
                }
                mySequence = ((~yourSequence << 1) & 0b100) | (yourSequence >> 1);
            } else {
                for (int i = 0; i < N; i++) {
                    mySequence = (mySequence << 1) + Toss();
                }

                WriteLine("I chose " + mySequence.AsString());
                do {
                    WriteLine("Choose your sequence of (H)eads and (T)ails (or press Esc to exit)");
                    int choice;
                    yourSequence = 0;
                    for (int i = 0; i < N; i++) {
                        if ((choice = UserInput()) < 0) return;
                        yourSequence = (yourSequence << 1) + choice;
                    }
                    if (yourSequence == mySequence) {
                        WriteLine();
                        WriteLine("You cannot choose the same sequence.");
                    }
                } while (yourSequence == mySequence);
            }

            WriteLine();
            WriteLine($"Your sequence: {yourSequence.AsString()}, My sequence: {mySequence.AsString()}");
            WriteLine("Tossing...");
            int sequence = 0;
            for (int i = 0; i < N; i++) {
                Sleep(pause);
                int toss = Toss();
                sequence = (sequence << 1) + toss;
                Write(toss > 0 ? 'T' : 'H');
            }
            while (true) {
                if (sequence == yourSequence) {
                    WriteLine();
                    WriteLine("You win!");
                    yourScore++;
                    break;
                } else if (sequence == mySequence) {
                    WriteLine();
                    WriteLine("I win!");
                    myScore++;
                    break;
                }
                Sleep(pause);
                int toss = Toss();
                sequence = ((sequence << 1) + toss) & 0b111;
                Write(toss > 0 ? 'T' : 'H');
            }
            WriteLine("Press a key.");
            ReadKey();
            Clear();
        }
    }

}
