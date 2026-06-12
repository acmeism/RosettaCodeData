#include <iostream>
#include <string>
#include <vector>

std::vector<std::string> hist;

std::ostream& operator<<(std::ostream& os, const std::string& str) {
    return os << str.c_str();
}

void appendHistory(const std::string& name) {
    hist.push_back(name);
}

void hello() {
    std::cout << "Hello World!\n";
    appendHistory(__func__);
}

void history() {
    if (hist.size() == 0) {
        std::cout << "No history\n";
    } else {
        for (auto& str : hist) {
            std::cout << " - " << str << '\n';
        }
    }
    appendHistory(__func__);
}

void help() {
    std::cout << "Available commands:\n";
    std::cout << "  hello\n";
    std::cout << "  hist\n";
    std::cout << "  exit\n";
    std::cout << "  help\n";
    appendHistory(__func__);
}

int main() {
    bool done = false;
    std::string cmd;

    do {
        std::cout << "Enter a command, type help for a listing.\n";
        std::cin >> cmd;
        for (size_t i = 0; i < cmd.size(); ++i) {
            cmd[i] = toupper(cmd[i]);
        }

        if (strcmp(cmd.c_str(), "HELLO") == 0) {
            hello();
        } else if (strcmp(cmd.c_str(), "HIST") == 0) {
            history();
        } else if (strcmp(cmd.c_str(), "EXIT") == 0) {
            done = true;
        } else {
            help();
        }
    } while (!done);

    return 0;
}
