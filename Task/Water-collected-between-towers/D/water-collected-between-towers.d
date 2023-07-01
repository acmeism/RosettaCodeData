import std.stdio;

void main() {
    int i = 1;
    int[][] tba = [
        [ 1, 5, 3, 7, 2 ],
        [ 5, 3, 7, 2, 6, 4, 5, 9, 1, 2 ],
        [ 2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1 ],
        [ 5, 5, 5, 5 ],
        [ 5, 6, 7, 8 ],
        [ 8, 7, 7, 6 ],
        [ 6, 7, 10, 7, 6 ]
    ];

    foreach (tea; tba) {
        int rht, wu, bof;
        do {
            for (rht = tea.length - 1; rht >= 0; rht--) {
                if (tea[rht] > 0) {
                    break;
                }
            }

            if (rht < 0) {
                break;
            }

            bof = 0;
            for (int col = 0; col <= rht; col++) {
                if (tea[col] > 0) {
                    tea[col] -= 1; bof += 1;
                } else if (bof > 0) {
                    wu++;
                }
            }
            if (bof < 2) {
                break;
            }
        } while (true);

        write("Block ", i++);
        if (wu == 0) {
            write(" does not hold any");
        } else {
            write(" holds ", wu);
        }
        writeln(" water units.");
    }
}
