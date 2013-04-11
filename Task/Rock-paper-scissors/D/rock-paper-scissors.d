import std.stdio, std.random, std.string, std.array;

enum string[] order = ["rock", "paper", "scissors"];
int[string] choiceFrequency; // mutable

immutable(string[string]) whatBeats;
nothrow pure static this() {
    whatBeats = ["paper": "scissors",
                 "scissors": "rock",
                 "rock": "paper"];
}

string checkWinner(in string a, in string b) pure nothrow {
    if (b == whatBeats[a])
        return b;
    else if (a == whatBeats[b])
        return a;
    return "";
}

string getRandomChoice() /*nothrow*/ {
    //if (choiceFrequency.empty)
    if (choiceFrequency.length == 0)
        return order[uniform(0, $)];
    const choices = choiceFrequency.keys;
    const probabilities = choiceFrequency.values;
    return whatBeats[choices[dice(probabilities)]];
}

void main() {
    writeln("Rock-paper-scissors game");
    while (true) {
        write("Your choice: ");
        immutable string humanChoice = readln().strip().toLower();
        if (humanChoice.empty)
            break;
        if (humanChoice !in whatBeats) {
            writeln("Wrong input: ", humanChoice);
            continue;
        }

        immutable compChoice = getRandomChoice();
        write("Computer picked ", compChoice, ", ");

        // Don't register the player choice until after
        // the computer has made its choice.
        choiceFrequency[humanChoice]++;

        immutable winner = checkWinner(humanChoice, compChoice);
        if (winner.empty)
            writeln("nobody wins!");
        else
            writeln(winner, " wins!");
    }
}
