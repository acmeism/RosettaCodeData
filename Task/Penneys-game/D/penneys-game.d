void main() {
    import std.stdio, std.random, std.algorithm, std.string,
           std.conv, std.range, core.thread;

    immutable first = uniform(0, 2) == 0;

    string you, me;
    if (first) {
        me = 3.iota.map!(_ => "HT"[uniform(0, $)]).text;
        writefln("I choose first and will win on first seeing %s in the list of tosses", me);
        while (you.length != 3 || you.any!(c => !c.among('H', 'T')) || you == me) {
            "What sequence of three Heads/Tails will you win with: ".write;
            you = readln.strip;
        }
    } else {
        while (you.length != 3 || you.any!(c => !c.among('H', 'T'))) {
            "After you: What sequence of three Heads/Tails will you win with: ".write;
            you = readln.strip;
        }
        me = (you[1] == 'T' ? 'H' : 'T') ~ you[0 .. 2];
        writefln("I win on first seeing %s in the list of tosses", me);
    }

    "Rolling:\n  ".write;
    string rolled;
    while (true) {
        rolled ~= "HT"[uniform(0, $)];
        rolled.back.write;
        if (rolled.endsWith(you))
            return "\n  You win!".writeln;
        if (rolled.endsWith(me))
            return "\n  I win!".writeln;
        Thread.sleep(1.seconds);
    }
}
