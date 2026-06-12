#include <iostream>
#include <string>
#include <unordered_map>
#include <stack>
#include <vector>
#include <set>

// Define the State structure
struct State {
    char label;       // Character label, '\0' for epsilon
    State* edge1;     // First transition
    State* edge2;     // Second transition

    State(char lbl = '\0') : label(lbl), edge1(nullptr), edge2(nullptr) {}
};

// Define the NFA structure
struct NFA {
    State* initial;
    State* accept;

    NFA(State* init = nullptr, State* acc = nullptr) : initial(init), accept(acc) {}
};

// Function to convert infix regex to postfix using the Shunting Yard algorithm
std::string shunt(const std::string& infix) {
    std::unordered_map<char, int> specials = {
        {'*', 60},
        {'+', 55},
        {'?', 50},
        {'.', 40},
        {'|', 20}
    };
    std::string postfix;
    std::stack<char> stack;

    for (char c : infix) {
        if (c == '(') {
            stack.push(c);
        }
        else if (c == ')') {
            while (!stack.empty() && stack.top() != '(') {
                postfix += stack.top();
                stack.pop();
            }
            if (!stack.empty()) {
                stack.pop(); // Remove '('
            }
        }
        else if (specials.find(c) != specials.end()) {
            while (!stack.empty() && specials.find(stack.top()) != specials.end() &&
                   specials[c] <= specials[stack.top()]) {
                postfix += stack.top();
                stack.pop();
            }
            stack.push(c);
        }
        else {
            postfix += c;
        }
    }

    while (!stack.empty()) {
        postfix += stack.top();
        stack.pop();
    }

    return postfix;
}

// Function to compute the epsilon closure of a state
std::set<State*> followes(State* state) {
    std::set<State*> states;
    std::stack<State*> stack;
    stack.push(state);

    while (!stack.empty()) {
        State* s = stack.top();
        stack.pop();
        if (states.find(s) == states.end()) {
            states.insert(s);
            if (s->label == '\0') { // Epsilon transition
                if (s->edge1 != nullptr) {
                    stack.push(s->edge1);
                }
                if (s->edge2 != nullptr) {
                    stack.push(s->edge2);
                }
            }
        }
    }

    return states;
}

// Function to compile postfix regex into an NFA
NFA compileRegex(const std::string& postfix) {
    std::stack<NFA> nfaStack;

    for (char c : postfix) {
        if (c == '*') {
            NFA nfa1 = nfaStack.top(); nfaStack.pop();
            State* initial = new State();
            State* accept = new State();
            initial->edge1 = nfa1.initial;
            initial->edge2 = accept;
            nfa1.accept->edge1 = nfa1.initial;
            nfa1.accept->edge2 = accept;
            nfaStack.push(NFA(initial, accept));
        }
        else if (c == '.') {
            NFA nfa2 = nfaStack.top(); nfaStack.pop();
            NFA nfa1 = nfaStack.top(); nfaStack.pop();
            nfa1.accept->edge1 = nfa2.initial;
            nfaStack.push(NFA(nfa1.initial, nfa2.accept));
        }
        else if (c == '|') {
            NFA nfa2 = nfaStack.top(); nfaStack.pop();
            NFA nfa1 = nfaStack.top(); nfaStack.pop();
            State* initial = new State();
            State* accept = new State();
            initial->edge1 = nfa1.initial;
            initial->edge2 = nfa2.initial;
            nfa1.accept->edge1 = accept;
            nfa2.accept->edge1 = accept;
            nfaStack.push(NFA(initial, accept));
        }
        else if (c == '+') {
            NFA nfa1 = nfaStack.top(); nfaStack.pop();
            State* initial = new State();
            State* accept = new State();
            initial->edge1 = nfa1.initial;
            nfa1.accept->edge1 = nfa1.initial;
            nfa1.accept->edge2 = accept;
            nfaStack.push(NFA(initial, accept));
        }
        else if (c == '?') {
            NFA nfa1 = nfaStack.top(); nfaStack.pop();
            State* initial = new State();
            State* accept = new State();
            initial->edge1 = nfa1.initial;
            initial->edge2 = accept;
            nfa1.accept->edge1 = accept;
            nfaStack.push(NFA(initial, accept));
        }
        else { // Literal character
            State* initial = new State(c);
            State* accept = new State();
            initial->edge1 = accept;
            nfaStack.push(NFA(initial, accept));
        }
    }

    return nfaStack.top();
}

// Function to match a string against the regex
bool matchRegex(const std::string& infix, const std::string& str) {
    std::string postfix = shunt(infix);
    // Uncomment the next line to see the postfix expression
    // std::cout << "Postfix: " << postfix << std::endl;

    NFA nfa = compileRegex(postfix);

    std::set<State*> current = followes(nfa.initial);
    std::set<State*> nextStates;

    for (char c : str) {
        for (State* state : current) {
            if (state->label == c) {
                std::set<State*> follow = followes(state->edge1);
                nextStates.insert(follow.begin(), follow.end());
            }
        }
        current = nextStates;
        nextStates.clear();
    }

    return current.find(nfa.accept) != current.end();
}

int main() {
    std::vector<std::string> infixes = {"a.b.c*", "a.(b|d).c*", "(a.(b|d))*", "a.(b.b)*.c"};
    std::vector<std::string> strings = {"", "abc", "abbc", "abcc", "abad", "abbbc"};

    for (const auto& infix : infixes) {
        for (const auto& str : strings) {
            bool result = matchRegex(infix, str);
            std::cout << (result ? "True " : "False ") << infix << " " << str << std::endl;
        }
        std::cout<<"\n";
    }

    return 0;
}
