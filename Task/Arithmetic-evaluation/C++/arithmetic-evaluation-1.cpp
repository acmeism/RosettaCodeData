#include <iostream>
#include <vector>
#include <cmath>
using namespace std;

template <class T>
class stack {
    private:
        vector<T> st;
        T sentinel;
    public:
        stack() { sentinel = T(); }
        bool empty() { return st.empty(); }
        void push(T info) { st.push_back(info); }
        T& top() {
            if (!st.empty()) {
                return st.back();
            }
            return sentinel;
        }
        T pop() {
            T ret = top();
            if (!st.empty()) st.pop_back();
            return ret;
        }
};

//determine associativity of operator, returns true if left, false if right
bool leftAssociate(char c) {
    switch (c) {
        case '^': return false;
        case '*': return true;
        case '/': return true;
        case '%': return true;
        case '+': return true;
        case '-': return true;
        default:
            break;
    }
    return false;
}

//determins precedence level of operator
int precedence(char c) {
    switch (c) {
        case '^': return 7;
        case '*': return 5;
        case '/': return 5;
        case '%': return 5;
        case '+': return 3;
        case '-': return 3;
        default:
            break;
    }
    return 0;
}

//converts infix expression string to postfix expression string
string shuntingYard(string expr) {
    stack<char> ops;
    string output;
    for (char c : expr) {
        if (c == '(') {
            ops.push(c);
        } else if (c == '+' || c == '-' || c == '*' || c == '/' || c == '^' || c == '%') {
                if (precedence(c) < precedence(ops.top()) ||
                   (precedence(c) == precedence(ops.top()) && leftAssociate(c))) {
                    output.push_back(' ');
                    output.push_back(ops.pop());
                    output.push_back(' ');
                    ops.push(c);
                } else {
                    ops.push(c);
                    output.push_back(' ');
                }
        } else if (c == ')') {
            while (!ops.empty()) {
                if (ops.top() != '(') {
                    output.push_back(ops.pop());
                } else {
                    ops.pop();
                    break;
                }
            }
        } else {
            output.push_back(c);
        }
    }
    while (!ops.empty())
        if (ops.top() != '(')
            output.push_back(ops.pop());
        else ops.pop();
    cout<<"Postfix: "<<output<<endl;
    return output;
}

struct Token {
    int type;
    union {
        double num;
        char op;
    };
    Token(double n) : type(0), num(n) { }
    Token(char c) : type(1), op(c) { }
};

//converts postfix expression string to vector of tokens
vector<Token> lex(string pfExpr) {
    vector<Token> tokens;
    for (int i = 0; i < pfExpr.size(); i++) {
        char c = pfExpr[i];
        if (isdigit(c)) {
            string num;
            do {
                num.push_back(c);
                c = pfExpr[++i];
            } while (i < pfExpr.size() && isdigit(c));
            tokens.push_back(Token(stof(num)));
            i--;
            continue;
        } else if (c == '+' || c == '-' || c == '*' || c == '/' || c == '^' || c == '%') {
            tokens.push_back(Token(c));
        }
    }
    return tokens;
}

//structure used for nodes of expression tree
struct node {
    Token token;
    node* left;
    node* right;
    node(Token tok) : token(tok), left(nullptr), right(nullptr) { }
};

//builds expression tree from vector of tokens
node* buildTree(vector<Token> tokens) {
    cout<<"Building Expression Tree: "<<endl;
    stack<node*> sf;
    for (int i = 0; i < tokens.size(); i++) {
        Token c = tokens[i];
        if (c.type == 1) {
            node* x = new node(c);
            x->right = sf.pop();
            x->left = sf.pop();
            sf.push(x);
            cout<<"Push Operator Node: "<<sf.top()->token.op<<endl;
        } else
        if (c.type == 0) {
            sf.push(new node(c));
            cout<<"Push Value Node: "<<c.num<<endl;
            continue;
        }
    }
    return sf.top();
}

//evaluate expression tree, while anotating steps being performed.
int recd = 0;
double eval(node* x) {
    recd++;
    if (x == nullptr) {
        recd--;
        return 0;
    }
    if (x->token.type == 0) {
        for (int i = 0; i < recd; i++) cout<<"  ";
        cout<<"Value Node: "<<x->token.num<<endl;
        recd--;
        return x->token.num;
    }
    if (x->token.type == 1) {
        for (int i = 0; i < recd; i++) cout<<"  ";
        cout<<"Operator Node: "<<x->token.op<<endl;
        double lhs = eval(x->left);
        double rhs = eval(x->right);
        for (int i = 0; i < recd; i++) cout<<"  ";
        cout<<lhs<<" "<<x->token.op<<" "<<rhs<<endl;
        recd--;
        switch (x->token.op) {
            case '^': return pow(lhs, rhs);
            case '*': return lhs*rhs;
            case '/':
                if (rhs == 0) {
                    cout<<"Error: divide by zero."<<endl;
                } else
                    return lhs/rhs;
            case '%':
                return (int)lhs % (int)rhs;
            case '+': return lhs+rhs;
            case '-': return lhs-rhs;
            default:
            break;
        }
    }
    return 0;
}

int main() {
    string expr = "3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3";
    cout<<eval(buildTree(lex(shuntingYard(expr))))<<endl;
    return 0;
}

Output:
Postfix: 3   4   2  *   1   5 -   2   3^^/+
Building Expression Tree:
Push Value Node: 3
Push Value Node: 4
Push Value Node: 2
Push Operator Node: *
Push Value Node: 1
Push Value Node: 5
Push Operator Node: -
Push Value Node: 2
Push Value Node: 3
Push Operator Node: ^
Push Operator Node: ^
Push Operator Node: /
Push Operator Node: +
  Operator Node: +
    Value Node: 3
    Operator Node: /
      Operator Node: *
        Value Node: 4
        Value Node: 2
      4 * 2
      Operator Node: ^
        Operator Node: -
          Value Node: 1
          Value Node: 5
        1 - 5
        Operator Node: ^
          Value Node: 2
          Value Node: 3
        2 ^ 3
      -4 ^ 8
    8 / 65536
  3 + 0.00012207
3.00012
