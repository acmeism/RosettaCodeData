#include <iostream>
#include <vector>
#include <string>
#include <algorithm>

using namespace std;

vector<string> duval(string const& s) {
    int n = s.size();
    int i = 0;
    vector<string> factorization;
    while (i < n) {
        int j = i + 1, k = i;
        while (j < n && s[k] <= s[j]) {
            if (s[k] < s[j])
                k = i;
            else
                k++;
            j++;
        }
        while (i <= k) {
            factorization.push_back(s.substr(i, j - k));
            i += j - k;
        }
    }
    return factorization;
}

int main() {
    // Thue-Morse example
    string m = "0";
    for (int i = 0; i < 7; ++i) {
        string m0 = m;
        replace(m.begin(), m.end(), '0', 'a');
        replace(m.begin(), m.end(), '1', '0');
        replace(m.begin(), m.end(), 'a', '1');
        m = m0 + m;
    }
    for (string s : duval(m)) cout << s << endl;
    return 0;
}
