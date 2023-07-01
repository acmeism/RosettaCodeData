#include <iostream>
#include <fstream>
#include <cmath>

using namespace std;

string readFile (string path) {
    string contents;
    string line;
    ifstream inFile(path);
    while (getline (inFile, line)) {
        contents.append(line);
        contents.append("\n");
    }
    inFile.close();
    return contents;
}

double entropy (string X) {
    const int MAXCHAR = 127;
    int N = X.length();
    int count[MAXCHAR];
    double count_i;
    char ch;
    double sum = 0.0;
    for (int i = 0; i < MAXCHAR; i++) count[i] = 0;
    for (int pos = 0; pos < N; pos++) {
        ch = X[pos];
        count[(int)ch]++;
    }
    for (int n_i = 0; n_i < MAXCHAR; n_i++) {
        count_i = count[n_i];
        if (count_i > 0) sum -= count_i / N * log2(count_i / N);
    }
    return sum;
}

int main () {
    cout<<entropy(readFile("entropy.cpp"));
    return 0;
}
