#include <iostream>
#include <stdexcept>
#include <string>
#include <vector>

using namespace std;

vector<string> tokenize(const string& input, char seperator, char escape) {
    vector<string> output;
    string token;

    bool inEsc = false;
    for (char ch : input) {
        if (inEsc) {
            inEsc = false;
        } else if (ch == escape) {
            inEsc = true;
            continue;
        } else if (ch == seperator) {
            output.push_back(token);
            token = "";
            continue;
        }
        token += ch;
    }
    if (inEsc)
        throw new invalid_argument("Invalid terminal escape");

    output.push_back(token);
    return output;
}

int main() {
    string sample = "one^|uno||three^^^^|four^^^|^cuatro|";

    cout << sample << endl;
    cout << '[';
    for (auto t : tokenize(sample, '|', '^')) {
        cout << '"' << t << "\", ";
    }
    cout << ']' << endl;

    return 0;
}
