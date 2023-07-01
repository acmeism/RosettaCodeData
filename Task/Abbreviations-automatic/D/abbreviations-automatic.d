import std.conv;
import std.exception;
import std.range;
import std.stdio;
import std.string;

void main() {
    foreach (size_t i, dstring line; File("days_of_week.txt").lines) {
        line = chomp(line);
        if (!line.empty) {
            auto days = line.split;
            enforce(days.length==7, text("There aren't 7 days in line ", i+1));

            int[dstring] temp;
            foreach(day; days) {
                temp[day]++;
            }
            if (days.length < 7) {
                writeln(" ∞  ", line);
                continue;
            }
            int len = 1;
            while (true) {
                temp.clear();
                foreach (day; days) {
                    temp[day.take(len).array]++;
                }
                if (temp.length == 7) {
                    writefln("%2d  %s", len, line);
                    break;
                }
                len++;
            }
        }
    }
}
