#include <iostream>
#include <stack>
#include <string>
#include <sstream>
#include <vector>

struct var {
    char name;
    bool value;
};
std::vector<var> vars;

template<typename T>
T pop(std::stack<T> &s) {
    auto v = s.top();
    s.pop();
    return v;
}

bool is_operator(char c) {
    return c == '&' || c == '|' || c == '!' || c == '^';
}

bool eval_expr(const std::string &expr) {
    std::stack<bool> sob;
    for (auto e : expr) {
        if (e == 'T') {
            sob.push(true);
        } else if (e == 'F') {
            sob.push(false);
        } else {
           auto it = std::find_if(vars.cbegin(), vars.cend(), [e](const var &v) { return v.name == e; });
           if (it != vars.cend()) {
               sob.push(it->value);
           } else {
               int before = sob.size();
               switch (e) {
               case '&':
                   sob.push(pop(sob) & pop(sob));
                   break;
               case '|':
                   sob.push(pop(sob) | pop(sob));
                   break;
               case '!':
                   sob.push(!pop(sob));
                   break;
               case '^':
                   sob.push(pop(sob) ^ pop(sob));
                   break;
               default:
                   throw std::exception("Non-conformant character in expression.");
               }
           }
        }
    }
    if (sob.size() != 1) {
        throw std::exception("Stack should contain exactly one element.");
    }
    return sob.top();
}

void set_vars(int pos, const std::string &expr) {
    if (pos > vars.size()) {
        throw std::exception("Argument to set_vars can't be greater than the number of variables.");
    }
    if (pos == vars.size()) {
        for (auto &v : vars) {
            std::cout << (v.value ? "T  " : "F  ");
        }
        std::cout << (eval_expr(expr) ? 'T' : 'F') << '\n'; //todo implement evaluation
    } else {
        vars[pos].value = false;
        set_vars(pos + 1, expr);
        vars[pos].value = true;
        set_vars(pos + 1, expr);
    }
}

/* removes whitespace and converts to upper case */
std::string process_expr(const std::string &src) {
    std::stringstream expr;

    for (auto c : src) {
        if (!isspace(c)) {
            expr << (char)toupper(c);
        }
    }

    return expr.str();
}

int main() {
    std::cout << "Accepts single-character variables (except for 'T' and 'F',\n";
    std::cout << "which specify explicit true or false values), postfix, with\n";
    std::cout << "&|!^ for and, or, not, xor, respectively; optionally\n";
    std::cout << "seperated by whitespace. Just enter nothing to quit.\n";

    while (true) {
        std::cout << "\nBoolean expression: ";

        std::string input;
        std::getline(std::cin, input);

        auto expr = process_expr(input);
        if (expr.length() == 0) {
            break;
        }

        vars.clear();
        for (auto e : expr) {
            if (!is_operator(e) && e != 'T' && e != 'F') {
                vars.push_back({ e, false });
            }
        }
        std::cout << '\n';
        if (vars.size() == 0) {
            std::cout << "No variables were entered.\n";
        } else {
            for (auto &v : vars) {
                std::cout << v.name << "  ";
            }
            std::cout << expr << '\n';

            auto h = vars.size() * 3 + expr.length();
            for (size_t i = 0; i < h; i++) {
                std::cout << '=';
            }
            std::cout << '\n';

            set_vars(0, expr);
        }
    }

    return 0;
}
