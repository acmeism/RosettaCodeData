import std.stdio, std.random, std.string, std.array,
       std.typecons, std.traits, std.conv, std.algorithm;

enum Choice { rock, paper, scissors }
immutable order = [EnumMembers!Choice];

uint[order.length] choiceFrequency;

Choice whatBeats(in Choice ch) pure /*nothrow*/ {
    return order[(order.countUntil(ch) + 1) % $];
}

Nullable!Choice checkWinner(in Choice a, in Choice b)
pure /*nothrow*/ {
    alias TResult = typeof(return);

    if (b == whatBeats(a))
        return TResult(b);
    else if (a == whatBeats(b))
        return TResult(a);
    return TResult();
}

Choice getRandomChoice() /*nothrow*/ {
    if (choiceFrequency[].reduce!q{a + b} == 0)
        return uniform!Choice;
    return order[choiceFrequency.dice].whatBeats;
}

void main() {
    writeln("Rock-Paper-Scissors Game");

    while (true) {
        write("Your choice (empty to end game): ");
        immutable humanChoiceStr = readln.strip.toLower;
        if (humanChoiceStr.empty)
            break;

        Choice humanChoice;
        try {
            humanChoice = humanChoiceStr.to!Choice;
        } catch (ConvException e) {
            writeln("Wrong input: ", humanChoiceStr);
            continue;
        }

        immutable compChoice = getRandomChoice;
        write("Computer picked ", compChoice, ", ");

        // Don't register the player choice until after
        // the computer has made its choice.
        choiceFrequency[humanChoice]++;

        immutable winner = checkWinner(humanChoice, compChoice);
        if (winner.isNull)
            writeln("Nobody wins!");
        else
            writeln(winner.get, " wins!");
    }
}
