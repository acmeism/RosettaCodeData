import std.conv;
import std.stdio;

bool isHumble(int i) {
    if (i <= 1) return true;
    if (i % 2 == 0) return isHumble(i / 2);
    if (i % 3 == 0) return isHumble(i / 3);
    if (i % 5 == 0) return isHumble(i / 5);
    if (i % 7 == 0) return isHumble(i / 7);
    return false;
}

void main() {
    auto limit = short.max;
    int[int] humble;
    auto count = 0;
    auto num = 1;

    while (count < limit) {
        if (isHumble(num)) {
            auto str = num.to!string;
            auto len = str.length;
            humble[len]++;
            if (count < 50) write(num, ' ');
            count++;
        }
        num++;
    }
    writeln('\n');

    writeln("Of the first ", count, " humble numbers:");
    num = 1;
    while (num < humble.length - 1) {
        if (num in humble) {
            auto c = humble[num];
            writefln("%5d have %2d digits", c, num);
            num++;
        } else {
            break;
        }
    }
}
