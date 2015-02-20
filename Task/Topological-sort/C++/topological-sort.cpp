#include <unordered_map>
#include <string>
#include <sstream>
#include <vector>
#include <iostream>

using namespace std;

string input = {
	"des_system_lib   std synopsys std_cell_lib des_system_lib dw02 dw01 ramlib ieee\n"
	"dw01             ieee dw01 dware gtech\n"
	"dw02             ieee dw02 dware\n"
	"dw03             std synopsys dware dw03 dw02 dw01 ieee gtech\n"
	"dw04             dw04 ieee dw01 dware gtech\n"
	"dw05             dw05 ieee dware\n"
	"dw06             dw06 ieee dware\n"
	"dw07             ieee dware\n"
	"dware            ieee dware\n"
	"gtech            ieee gtech\n"
	"ramlib           std ieee\n"
	"std_cell_lib     ieee std_cell_lib\n"
	"synopsys\n"
	"cycle_11	  cycle_12\n"
	"cycle_12	  cycle_11\n"
	"cycle_21	  dw01 cycle_22 dw02 dw03\n"
	"cycle_22	  cycle_21 dw01 dw04" };

class TopSort {

  public:
    TopSort(const string& input){
      stringstream ss(input);
      string buf;

      while(getline(ss, buf)){
        stringstream ls(buf);
        string target, subtarget;
        ls >> target;

        while(ls >> subtarget){
          if(target.compare(subtarget) == 0)
            continue;

          dependencies.emplace(subtarget, 0);
          parents[subtarget].push_back(target);
          ++dependencies[target];
        }
      }
    }

    void solve(){
      for(const auto& pair : dependencies)
        if(pair.second == 0)
          sorted.push_back(pair.first);

      for(unsigned int i = 0; i < sorted.size(); ++i){
        string target = sorted[i];

        for(string& parent : parents[target])
          if(--dependencies[parent] == 0)
            sorted.push_back(parent);
      }

      for(const auto& pair : dependencies)
        if(pair.second != 0)
          unorderable.push_back(pair.first);
    }

    friend ostream& operator<<(ostream& os, const TopSort& ts) {
      for(const string& s : ts.sorted)
        os << s << endl;
      if(ts.unorderable.size() > 0){
        cout << "Unorderable:" << endl;
        for(const string& s : ts.unorderable)
          os << s << endl;
      }
      return os;
    }

  private:

    vector<string> sorted;
    vector<string> unorderable;

    unordered_map<string, int> dependencies;
    unordered_map<string, vector<string>> parents;
};

int main () {
  TopSort ts(input);
  ts.solve();
  cout << ts;
}
