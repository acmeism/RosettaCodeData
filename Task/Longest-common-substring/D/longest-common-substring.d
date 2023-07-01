import std.stdio;

string lcs(string a, string b) {
    int[][] lengths;
    lengths.length = a.length;
    for (int i=0; i<a.length; i++) {
        lengths[i].length = b.length;
    }

    int greatestLength;
    string output;
    for (int i=0; i<a.length; i++) {
        for (int j=0; j<b.length; j++) {
            if (a[i]==b[j]) {
                lengths[i][j] = i==0 || j==0 ? 1 : lengths[i-1][j-1] + 1;
                if (lengths[i][j] > greatestLength) {
                    greatestLength = lengths[i][j];
                    int start = i-greatestLength+1;
                    output = a[start..start+greatestLength];
                }
            } else {
                lengths[i][j] = 0;
            }
        }
    }
    return output;
}

void main() {
    writeln(lcs("testing123testing", "thisisatest"));
}
