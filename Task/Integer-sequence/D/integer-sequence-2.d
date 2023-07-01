import std.stdio, std.traits, std.bigint, std.string;

void integerSequence(T)() if (isIntegral!T || is(T == BigInt)) {
    T now = 1;
    T max = 0;
    static if (!is(T == BigInt))
        max = T.max;

    do
        write(now, " ");
    while (now++ != max);

    writeln("\nDone!");
}

void main() {
    writeln("How much time do you have?");
    writeln(" 0. I'm in hurry.");
    writeln(" 1. I've some time.");
    writeln(" 2. I'm on vacation.");
    writeln(" 3. I'm unemployed...");
    writeln(" 4. I'm immortal!");
    write("Enter 0-4 or nothing to quit: ");

    string answer;
    readf("%s\n", &answer);

    switch (answer.toLower()) {
        case "0": integerSequence!ubyte();  break;
        case "1": integerSequence!short();  break;
        case "2": integerSequence!uint();   break;
        case "3": integerSequence!long();   break;
        case "4": integerSequence!BigInt(); break;
        default: writeln("\nBye bye!");     break;
    }
}
