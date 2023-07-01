#include <iostream>
#include <sstream>
#include <stack>

std::string infixToPostfix(const std::string& infix) {
    const std::string ops = "-+/*^";
    std::stringstream ss;
    std::stack<int> s;

    std::stringstream input(infix);
    std::string token;
    while (std::getline(input, token, ' ')) {
        if (token.empty()) {
            continue;
        }

        char c = token[0];
        size_t idx = ops.find(c);

        // check for operator
        if (idx != std::string::npos) {
            while (!s.empty()) {
                int prec2 = s.top() / 2;
                int prec1 = idx / 2;
                if (prec2 > prec1 || (prec2 == prec1 && c != '^')) {
                    ss << ops[s.top()] << ' ';
                    s.pop();
                } else break;
            }
            s.push(idx);
        } else if (c == '(') {
            s.push(-2); // -2 stands for '('
        } else if (c == ')') {
            // until '(' on stack, pop operators.
            while (s.top() != -2) {
                ss << ops[s.top()] << ' ';
                s.pop();
            }
            s.pop();
        } else {
            ss << token << ' ';
        }
    }

    while (!s.empty()) {
        ss << ops[s.top()] << ' ';
        s.pop();
    }

    return ss.str();
}

int main() {
    std::string infix = "3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3";
    std::cout << "infix:   " << infix << '\n';
    std::cout << "postfix: " << infixToPostfix(infix) << '\n';

    return 0;
}
