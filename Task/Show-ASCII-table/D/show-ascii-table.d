import std.stdio;

void main() {
    for (int i = 0; i < 16; ++i) {
        for (int j = 32 + i; j < 128; j += 16) {
            switch (j) {
                case 32:
                    writef("%3d : Spc   ", j);
                    break;
                case 127:
                    writef("%3d : Del   ", j);
                    break;
                default:
                    writef("%3d : %-3s     ", j, cast(char)j);
                    break;
            }
        }
        writeln;
    }
}
