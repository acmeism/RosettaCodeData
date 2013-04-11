#include <iostream>
#include <fstream>
#include <string>

using namespace std;

int main() {
    string line;
    ifstream input ( "input.txt" );
    ofstream output ("output.txt");

    if (output.is_open()) {
        if (input.is_open()){
            while (getline (input,line)) {
                output << line << endl;
            }
            input.close(); // Not necessary - will be closed when variable goes out of scope.
        }
        else {
            cout << "input.txt cannot be opened!\n";
        }
        output.close(); // Not necessary - will be closed when variable goes out of scope.
    }
    else {
        cout << "output.txt cannot be written to!\n";
    }
    return 0;
}
