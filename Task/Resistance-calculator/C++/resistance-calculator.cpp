#include <cstdint>
#include <iomanip>
#include <iostream>
#include <map>
#include <memory>
#include <numeric>
#include <sstream>
#include <stack>
#include <string>
#include <vector>

class Resistor {
public:
	Resistor(const char& symbol, const double& resistance,
			 const std::shared_ptr<Resistor>& a, const std::shared_ptr<Resistor>& b)
	: symbol(symbol), resistance(resistance), voltage(0.0), a(a), b(b) {}

	Resistor(const char& symbol, const double& resistance)
	: symbol(symbol), resistance(resistance), voltage(0.0) {}

	char symbol;
	double resistance;
	double voltage;
	std::shared_ptr<Resistor> a;
	std::shared_ptr<Resistor> b;
};

double get_resistance(const std::shared_ptr<Resistor>& resistor) {
	switch ( resistor->symbol ) {
		case '+' : return get_resistance(resistor->a) + get_resistance(resistor->b);
		case '*' : return 1.0 / ( 1.0 / get_resistance(resistor->a) + 1.0 / get_resistance(resistor->b) );
		default  : return resistor->resistance;
	}
}

void set_voltage(const std::shared_ptr<Resistor>& resistor, const double& voltage) {
    switch ( resistor->symbol ) {
    	case '+' : {
    		const double ra = get_resistance(resistor->a);
    		const double rb = get_resistance(resistor->b);
    		set_voltage(resistor->a, ra / ( ra + rb ) * voltage);
        	set_voltage(resistor->b, rb / ( ra + rb ) * voltage);
        	resistor->voltage = resistor->a->voltage + resistor->b->voltage;
    		break;
    	}
    	case '*' : {
    		set_voltage(resistor->a, voltage);
        	set_voltage(resistor->b, voltage);
        	resistor->voltage = voltage;
        	break;
    	}
    	default : resistor->voltage = voltage;
    }
}

double get_current(const std::shared_ptr<Resistor>& resistor) {
    return resistor->voltage / get_resistance(resistor);
}

double get_power(const std::shared_ptr<Resistor>& resistor) {
    return resistor->voltage * get_current(resistor);
}

void report(const std::shared_ptr<Resistor>& resistor, const std::string& level) {
    std::cout << std::fixed << std::setprecision(3) << std::setw(8) << get_resistance(resistor)
    		  << std::setw(8) << resistor->voltage << std::setw(8) << get_current(resistor)
			  << std::setw(8) << get_power(resistor) << level << resistor->symbol << std::endl;
    if ( resistor->a ) {
        report(resistor->a, level + "| ");
    }
    if ( resistor->b ) {
        report(resistor->b, level + "| ");
    }
}

void report(const std::shared_ptr<Resistor>& resistor) {
	report(resistor, " ");
}

bool is_digit(const char& ch) {
    return ch >= '0' && ch <= '9';
}

std::string convert_to_RPN(const std::string& text) {
	std::map<char, uint32_t> precedence = { { '(', 0 }, { '+', 1 }, { '*', 2 } };

	std::vector<std::string> items{ };
	std::stack<char> stack{ };
	uint32_t end = 0;
	while ( end < text.length() ) {
		uint32_t start = end;
		const char ch = text[end];
		end += 1;
		if ( ch == '(' ) {
			stack.push(ch);
		} else if ( ch == '+' || ch == '*' ) {
			while ( ! stack.empty() && precedence[ch] <= precedence[stack.top()] ) {
				items.emplace_back(std::string(1, stack.top()) + " "); stack.pop();
			}
			stack.push(ch);
		} else if ( ch == ')' ) {
			while ( stack.top() != '(' ) {
				items.emplace_back(std::string(1, stack.top()) + " "); stack.pop();
			}
			stack.pop();
		} else {
			if ( is_digit(ch) ) {
				while ( end < text.length() && is_digit(text[end]) ) {
					end += 1;
				}
				items.emplace_back(text.substr(start, end - start) + " "); // Extract a multi-digit number
			}
		}
	}

	while ( ! stack.empty() ) {
		items.emplace_back(std::string(1, stack.top()) + " "); stack.pop();
	}
	return std::accumulate(items.begin(), items.end(), std::string{ });
}

std::vector<std::string> split_string(const std::string& text, const char& delimiter) {
	std::vector<std::string> words;
	std::istringstream stream(text);
	std::string word;
	while ( std::getline(stream, word, delimiter) ) {
	    words.emplace_back(word);
	}
    return words;
}

std::shared_ptr<Resistor> build(const std::string& text) {
    std::stack<std::shared_ptr<Resistor>> stack{ };
    for ( const std::string& word : split_string(text, ' ') ) {
        if ( word == "+" ) {
			std::shared_ptr<Resistor> b = stack.top(); stack.pop();
			std::shared_ptr<Resistor> a = stack.top(); stack.pop();
			std::shared_ptr<Resistor> resistor = std::make_shared<Resistor>( '+', 0.0, a, b );
			stack.push(resistor);
		} else if ( word == "*" ) {
        	std::shared_ptr<Resistor> b = stack.top(); stack.pop();
			std::shared_ptr<Resistor> a = stack.top(); stack.pop();
			std::shared_ptr<Resistor> resistor = std::make_shared<Resistor>( '*', 0.0, a, b );
			stack.push(resistor);
        } else {
        	const double value = std::stod(word);
        	std::shared_ptr<Resistor> resistor = std::make_shared<Resistor>( 'r', value );
        	stack.push(resistor);
        }
    }

    std::shared_ptr<Resistor> result = stack.top(); stack.pop();
    return result;
}

void calculator(const std::string& title, const std::string& resistors, const double& voltage) {
	std::cout << title << std::endl;
	std::shared_ptr<Resistor> root = build(resistors);
	std::cout << "    Ohm    Volt   Ampere   Watt  Network tree" << std::endl;
	set_voltage(root, voltage);
	report(root);
}

int main() {
	calculator("RPN syntax:", "10 2 + 6 * 8 + 6 * 4 + 8 * 4 + 8 * 6 +", 18.0);
	std::cout << std::endl;

	calculator("Infix syntax:", convert_to_RPN("((((10 + 2) * 6 + 8) * 6 + 4) * 8 + 4) * 8 + 6"), 18.0);
}
