import std.stdio;

void main() {
    int[] mem = [
         15,  17,  -1,  17,  -1,  -1,  16,   1,
         -1,  16,   3,  -1,  15,  15,   0,   0,
         -1,  72, 101, 108, 108, 111,  44,  32,
        119, 111, 114, 108, 100,  33,  10,   0
    ];

    int instructionPointer = 0;

    do {
        int a = mem[instructionPointer];
        int b = mem[instructionPointer + 1];

        if (a == -1) {
            int input;
            readf!" %d"(input);
            mem[b] = input;
        } else if (b == -1) {
            write(cast(char) mem[a]);
        } else {
            mem[b] -= mem[a];
            if (mem[b] < 1) {
                instructionPointer = mem[instructionPointer + 2];
                continue;
            }
        }

        instructionPointer += 3;
    } while (instructionPointer >= 0);
}
