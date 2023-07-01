#include <regex>
#include <fstream>

using namespace std;
using ist = istreambuf_iterator<char>;
using ost = ostreambuf_iterator<char>;

int main(){
    auto from = "Goodbye London!", to = "Hello New York!";
    for(auto filename : {"a.txt", "b.txt", "c.txt"}) {
        ifstream infile {filename};
        string content {ist {infile}, ist{}};
        infile.close();
        ofstream outfile {filename};
        regex_replace(ost {outfile}, begin(content), end(content), regex {from}, to);
    }
    return 0;
}
