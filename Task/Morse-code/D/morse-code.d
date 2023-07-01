import std.conv;
import std.stdio;

immutable string[char] morsecode;

static this() {
    morsecode = [
        'a': ".-",
        'b': "-...",
        'c': "-.-.",
        'd': "-..",
        'e': ".",
        'f': "..-.",
        'g': "--.",
        'h': "....",
        'i': "..",
        'j': ".---",
        'k': "-.-",
        'l': ".-..",
        'm': "--",
        'n': "-.",
        'o': "---",
        'p': ".--.",
        'q': "--.-",
        'r': ".-.",
        's': "...",
        't': "-",
        'u': "..-",
        'v': "...-",
        'w': ".--",
        'x': "-..-",
        'y': "-.--",
        'z': "--..",
        '0': "-----",
        '1': ".----",
        '2': "..---",
        '3': "...--",
        '4': "....-",
        '5': ".....",
        '6': "-....",
        '7': "--...",
        '8': "---..",
        '9': "----."
    ];
}

void main(string[] args) {
    foreach (arg; args[1..$]) {
        writeln(arg);
        foreach (ch; arg) {
            if (ch in morsecode) {
                write(morsecode[ch]);
            }
            write(' ');
        }
        writeln();
    }
}
