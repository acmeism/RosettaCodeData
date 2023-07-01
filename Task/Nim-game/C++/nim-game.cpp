#include <iostream>
#include <limits>

using namespace std;

void showTokens(int tokens) {
    cout << "Tokens remaining " << tokens << endl << endl;
}

int main() {
    int tokens = 12;
    while (true) {
        showTokens(tokens);
        cout << "  How many tokens 1, 2 or 3? ";
        int t;
        cin >> t;
        if (cin.fail()) {
            cin.clear();
            cin.ignore(numeric_limits<streamsize>::max(), '\n');
            cout << endl << "Invalid input, try again." << endl << endl;
        } else if (t < 1 || t > 3) {
            cout << endl << "Must be a number between 1 and 3, try again." << endl << endl;
        } else {
            int ct = 4 - t;
            string s  = (ct > 1) ? "s" : "";
            cout << "  Computer takes " << ct << " token" << s << endl << endl;
            tokens -= 4;
        }
        if (tokens == 0) {
            showTokens(0);
            cout << "  Computer wins!" << endl;
            return 0;
        }
    }
}
