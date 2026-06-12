module readline_interface;

import std.stdio;
import std.string;

alias VOIDF = void function();

void hello() {
    writeln("Hello World!");
    histArr ~= __FUNCTION__;
}

string[] histArr;
void hist() {
    if (histArr.length == 0) {
        writeln("No history");
    } else {
        foreach(cmd; histArr) {
            writeln(" - ", cmd);
        }
    }
    histArr ~= __FUNCTION__;
}

void help() {
    writeln("Available commands:");
    writeln("  hello");
    writeln("  hist");
    writeln("  exit");
    writeln("  help");
    histArr ~= __FUNCTION__;
}

void main() {
    VOIDF[string] aa;
    aa["help"] = &help;
    aa["hist"] = &hist;
    aa["hello"] = &hello;

    writeln("Enter a command, type help for a listing.");

    string line;

    write(">");
    while ((line = readln()) !is null) {
        line = chomp(line);
        if (line == "exit") {
            break;
        }
        aa.get(line, &help)();
        write(">");
    }
}
