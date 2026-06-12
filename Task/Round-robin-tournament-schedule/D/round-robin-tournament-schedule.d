import std.stdio;
import std.range;
import std.array;
import std.conv;
import std.algorithm;

void main() {
    12.generatePlayers.generateSchedule.displaySchedule;
}

string[] generatePlayers(int n) {
    ("\nRound-Robin for "~(n).text~" players:\n").writeln;
    //
    return (n%2 == 0) ? iota(1, n+1).map!(a => a.text).array : iota(1, n+1).map!(a => a.text).array~"bye";
}

string[] mutate(string[] arr) {
    return arr[0]~arr[$-1]~ arr[1..$-1].array;
}

string[][] generateSchedule(string[] players) {
    auto nbPlayer = players.length;

    string[][]schedule;

    schedule ~= players;

    for(int i = 1; i <= nbPlayer-2; i++)
    {
        schedule ~= schedule[$-1].mutate;
    }

    //
    return schedule;
}

void displaySchedule(string[][] schedule) {
    auto nbPlayer = schedule[0].length;

    foreach(i, row; schedule.array)
    {
        writef("Round %2s:  ", i+1);

        for(int k=0; k<nbPlayer/2; k++)
        {
            writef("(%2s vs %2s)", row[k], row[nbPlayer-(k+1)]);
            if (k==(nbPlayer/2)-1) writeln; else "  ".write;
        }
    }

    //
    writeln;
}
