#include "stdafx.h"
#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <boost/tokenizer.hpp>
#include <boost/algorithm/string/case_conv.hpp>
using namespace std;
using namespace boost;

typedef boost::tokenizer<boost::char_separator<char> > Tokenizer;
static const char_separator<char> sep(" ","#;,");

//Assume that the config file represent a struct containing all the parameters to load
struct configs{
	string fullname;
	string favoritefruit;
	bool needspelling;
	bool seedsremoved;
	vector<string> otherfamily;
} conf;

void parseLine(const string &line, configs &conf)
{
	if (line[0] == '#' || line.empty())
		return;
	Tokenizer tokenizer(line, sep);
	vector<string> tokens;
	for (Tokenizer::iterator iter = tokenizer.begin(); iter != tokenizer.end(); iter++)
		tokens.push_back(*iter);
	if (tokens[0] == ";"){
		algorithm::to_lower(tokens[1]);
		if (tokens[1] == "needspeeling")
			conf.needspelling = false;
		if (tokens[1] == "seedsremoved")
			conf.seedsremoved = false;
	}
	algorithm::to_lower(tokens[0]);
	if (tokens[0] == "needspeeling")
		conf.needspelling = true;
	if (tokens[0] == "seedsremoved")
		conf.seedsremoved = true;
	if (tokens[0] == "fullname"){
		for (unsigned int i=1; i<tokens.size(); i++)
			conf.fullname += tokens[i] + " ";
		conf.fullname.erase(conf.fullname.size() -1, 1);
	}
	if (tokens[0] == "favouritefruit")
		for (unsigned int i=1; i<tokens.size(); i++)
			conf.favoritefruit += tokens[i];
	if (tokens[0] == "otherfamily"){
		unsigned int i=1;
		string tmp;
		while (i<=tokens.size()){		
			if ( i == tokens.size() || tokens[i] ==","){
				tmp.erase(tmp.size()-1, 1);
				conf.otherfamily.push_back(tmp);
				tmp = "";
				i++;
			}
			else{
				tmp += tokens[i];
				tmp += " ";
				i++;
			}
		}
	}
}

int _tmain(int argc, TCHAR* argv[])
{
	if (argc != 2)
	{
		wstring tmp = argv[0];
		wcout << L"Usage: " << tmp << L" <configfile.ini>" << endl;
		return -1;
	}
	ifstream file (argv[1]);
	
	if (file.is_open())
		while(file.good())
		{
			char line[255];
			file.getline(line, 255);
			string linestring(line);
			parseLine(linestring, conf);
		}
	else
	{
		cout << "Unable to open the file" << endl;
		return -2;
	}

	cout << "Fullname= " << conf.fullname << endl;
	cout << "Favorite Fruit= " << conf.favoritefruit << endl;
	cout << "Need Spelling= " << (conf.needspelling?"True":"False") << endl;
	cout << "Seed Removed= " << (conf.seedsremoved?"True":"False") << endl;
	string otherFamily;
	for (unsigned int i = 0; i < conf.otherfamily.size(); i++)
		otherFamily += conf.otherfamily[i] + ", ";
	otherFamily.erase(otherFamily.size()-2, 2);
	cout << "Other Family= " << otherFamily << endl;

	return 0;
}
