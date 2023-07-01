// Solution for http://rosettacode.org/wiki/Split_a_character_string_based_on_change_of_character
#include<string>
#include<iostream>

auto split(const std::string& input, const std::string& delim){
	std::string res;
	for(auto ch : input){
		if(!res.empty() && ch != res.back())
			res += delim;
		res += ch;
	}
	return res;
}

int main(){
	std::cout << split("gHHH5  ))YY++,,,///\\", ", ") << std::endl;
}
