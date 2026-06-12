#include <iostream>
#include <map>
#include <string>

using namespace std;

void lindenmayer(string s, map<char, string> rules, int count) {
	for (int i = 0; i < count; ++i) {
		cout << s << endl;
		string nxt = "";
		for (char c : s) {
			if (rules.find(c) != rules.end()) {
				nxt += rules[c];
			} else {
				nxt += c;
			}
		}
		s = nxt;
	}
}

int main() {
	map<char, string> rules = {{'I', "M"}, {'M', "MI"}};
	lindenmayer("I", rules, 5);
	return 0;
}
