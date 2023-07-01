// Jolkdarr was also here!
#include <iostream>
#include <iomanip>
#include <fstream>
#include <string>

int main() {
    using namespace std;
    ifstream file("data.txt");
    int count_quake = 0;
    string s1, s2;
    double rate;
    while (!file.eof()) {
        file >> s1 >> s2 >> rate;
        if (rate > 6.0) {
            cout << s1 << setw(20) << s2 << " " << rate << endl;
            count_quake++;
        }
    }

    cout << endl << "Number of quakes greater than 6 is " << count_quake << endl;
    return 0;
}
