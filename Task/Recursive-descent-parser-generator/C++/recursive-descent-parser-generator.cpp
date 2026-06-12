#include <fstream>
#include <iostream>
#include <map>
#include <regex>
#include <set>
#include <sstream>
#include <string>
using namespace std;

map<string, string> terminals;
map<string, vector<vector<string>>> nonterminalRules;
map<string, set<string>> nonterminalFirst;
map<string, vector<string>> nonterminalCode;

int main(int argc, char **argv) {
  if (argc < 3) {
    cout << "Usage: <input file> <output file>" << endl;
    return 1;
  }

  ifstream inFile(argv[1]);
  ofstream outFile(argv[2]);

  regex blankLine(R"(^\s*$)");
  regex terminalPattern(R"((\w+)\s+(.+))");
  regex rulePattern(R"(^!!\s*(\w+)\s*->\s*((?:\w+\s*)*)$)");
  regex argPattern(R"(\$(\d+))");
  smatch results;

  // Read terminal patterns
  string line;
  while (true) {
    getline(inFile, line);

    // Terminals section ends with a blank line
    if (regex_match(line, blankLine))
      break;

    regex_match(line, results, terminalPattern);
    terminals[results[1]] = results[2];
  }

  outFile << "#include <iostream>" << endl
          << "#include <fstream>" << endl
          << "#include <string>" << endl
          << "#include <regex>" << endl
          << "using namespace std;" << endl
          << endl;

  // Generate the token processing functions
  outFile << "string input, nextToken, nextTokenValue;" << endl
          << "string prevToken, prevTokenValue;" << endl
          << endl
          << "void advanceToken() {" << endl
          << "	static smatch results;" << endl
          << endl
          << "	prevToken = nextToken;" << endl
          << "	prevTokenValue = nextTokenValue;" << endl
          << endl;

  for (auto i = terminals.begin(); i != terminals.end(); ++i) {
    string name = i->first + "_pattern";
    string pattern = i->second;

    outFile << "	static regex " << name << "(R\"(^\\s*(" << pattern << "))\");" << endl
            << "	if (regex_search(input, results, " << name << ", regex_constants::match_continuous)) {" << endl
            << "		nextToken = \"" << i->first << "\";" << endl
            << "		nextTokenValue = results[1];" << endl
            << "		input = regex_replace(input, " << name << ", \"\");" << endl
            << "		return;" << endl
            << "	}" << endl
            << endl;
  }

  outFile << "	static regex eof(R\"(\\s*)\");" << endl
          << "	if (regex_match(input, results, eof, regex_constants::match_continuous)) {" << endl
          << "		nextToken = \"\";" << endl
          << "		nextTokenValue = \"\";" << endl
          << "		return;" << endl
          << "	}" << endl
          << endl
          << "	throw \"Unknown token\";" << endl
          << "}" << endl
          << endl
          << "bool same(string symbol) {" << endl
          << "	if (symbol == nextToken) {" << endl
          << "		advanceToken();" << endl
          << "		return true;" << endl
          << "	}" << endl
          << "	return false;" << endl
          << "}" << endl
          << endl;

  // Copy the header code to the output
  while (true) {
    getline(inFile, line);

    // Copy lines until we reach the first rule
    if (regex_match(line, results, rulePattern))
      break;

    outFile << line << endl;
  }

  // Build the nonterminal table
  while (true) {
    // results already contains the last matched rule
    string name = results[1];
    stringstream ss(results[2]);

    string tempString;
    vector<string> tempVector;
    while (ss >> tempString)
      tempVector.push_back(tempString);
    nonterminalRules[name].push_back(tempVector);

    // Read code until another rule is found
    string code = "";
    while (true) {
      getline(inFile, line);

      if (!inFile || regex_match(line, results, rulePattern))
        break;

      // Replace $1 with results[1], etc.
      line = regex_replace(line, argPattern, "results[$1]");

      code += line + "\n";
    }
    nonterminalCode[name].push_back(code);

    // Stop when we reach the end of the file
    if (!inFile)
      break;
  }

  // Generate the first sets, inefficiently
  bool done = false;
  while (!done)
    for (auto i = nonterminalRules.begin(); i != nonterminalRules.end(); ++i) {
      string name = i->first;
      done = true;

      if (nonterminalFirst.find(i->first) == nonterminalFirst.end())
        nonterminalFirst[i->first] = set<string>();

      for (int j = 0; j < i->second.size(); ++j) {
        if (i->second[j].size() == 0)
          nonterminalFirst[i->first].insert("");
        else {
          string first = i->second[j][0];
          if (nonterminalFirst.find(first) != nonterminalFirst.end()) {
            for (auto k = nonterminalFirst[first].begin(); k != nonterminalFirst[first].end(); ++k) {
              if (nonterminalFirst[name].find(*k) == nonterminalFirst[name].end()) {
                nonterminalFirst[name].insert(*k);
                done = false;
              }
            }
          } else if (nonterminalFirst[name].find(first) == nonterminalFirst[name].end()) {
            nonterminalFirst[name].insert(first);
            done = false;
          }
        }
      }
    }

  // Generate function signatures for the nonterminals
  for (auto i = nonterminalRules.begin(); i != nonterminalRules.end(); ++i) {
    string name = i->first + "_rule";
    outFile << "string " << name << "();" << endl;
  }
  outFile << endl;

  // Generate the nonterminal functions
  for (auto i = nonterminalRules.begin(); i != nonterminalRules.end(); ++i) {
    string name = i->first + "_rule";
    outFile << "string " << name << "() {" << endl
            << "	vector<string> results;" << endl
            << "	results.push_back(\"\");" << endl
            << endl;

    // Check if this rule can match an empty string
    int epsilon = -1;
    for (int j = 0; epsilon == -1 && j < i->second.size(); ++j)
      if (i->second[j].size() == 0)
        epsilon = j;

    // Generate each production
    for (int j = 0; j < i->second.size(); ++j) {
      // Nothing to generate for an empty rule
      if (j == epsilon)
        continue;

      string token = i->second[j][0];
      if (terminals.find(token) != terminals.end())
        outFile << "	if (nextToken == \"" << i->second[j][0] << "\") {" << endl;
      else {
        outFile << "	if (";
        bool first = true;
        for (auto k = nonterminalFirst[token].begin(); k != nonterminalFirst[token].end(); ++k, first = false) {
          if (!first)
            outFile << " || ";
          outFile << "nextToken == \"" << (*k) << "\"";
        }
        outFile << ") {" << endl;
      }

      for (int k = 0; k < i->second[j].size(); ++k) {
        if (terminals.find(i->second[j][k]) != terminals.end()) {
          outFile << "		if(same(\"" << i->second[j][k] << "\"))" << endl
                  << "			results.push_back(prevTokenValue);" << endl
                  << "		else" << endl
                  << "			throw \"Syntax error - mismatched token\";" << endl;
        } else
          outFile << "		results.push_back(" << i->second[j][k] << "_rule());" << endl;
      }

      // Copy rule code to output
      outFile << nonterminalCode[i->first][j];

      outFile << "	}" << endl << endl;
    }

    if (epsilon == -1)
      outFile << "	throw \"Syntax error - unmatched token\";" << endl;
    else
      outFile << nonterminalCode[i->first][epsilon];

    outFile << "}" << endl << endl;
  }

  // Generate the main function
  outFile << "int main(int argc, char **argv) {" << endl
          << "	if(argc < 2) {" << endl
          << "		cout << \"Usage: <input file>\" << endl;" << endl
          << "		return 1;" << endl
          << "	}" << endl
          << endl
          << "	ifstream file(argv[1]);" << endl
          << "	string line;" << endl
          << "	input = \"\";" << endl
          << endl
          << "	while(true) {" << endl
          << "		getline(file, line);" << endl
          << "		if(!file) break;" << endl
          << "		input += line + \"\\n\";" << endl
          << "	}" << endl
          << endl
          << "	advanceToken();" << endl
          << endl
          << "	start_rule();" << endl
          << "}" << endl;
}
