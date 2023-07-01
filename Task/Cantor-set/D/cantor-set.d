import std.stdio;

enum WIDTH = 81;
enum HEIGHT = 5;

char[WIDTH*HEIGHT] lines;

void cantor(int start, int len, int index) {
    int seg = len / 3;
    if (seg == 0) return;
    for (int i=index; i<HEIGHT; i++) {
        for (int j=start+seg; j<start+seg*2; j++) {
            int pos = i*WIDTH + j;
            lines[pos] = ' ';
        }
    }
    cantor(start, seg, index+1);
    cantor(start+seg*2, seg, index+1);
}

void main() {
    // init
    lines[] = '*';

    // calculate
    cantor(0, WIDTH, 1);

    // print
    for (int i=0; i<HEIGHT; i++) {
        int beg = WIDTH * i;
        writeln(lines[beg..beg+WIDTH]);
    }
}
