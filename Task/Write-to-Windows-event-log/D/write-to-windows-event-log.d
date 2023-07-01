import std.process;
import std.stdio;

void main() {
    auto cmd = executeShell(`EventCreate /t INFORMATION /id 123 /l APPLICATION /so Dlang /d "Rosetta Code Example"`);

    if (cmd.status == 0) {
        writeln("Output: ", cmd.output);
    } else {
        writeln("Failed to execute command, status=", cmd.status);
    }
}
