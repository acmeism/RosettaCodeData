#include <iostream>
#include <string>
#include <vector>

void print_menu(const std::vector<std::string>& terms)
{
    for (size_t i = 0; i < terms.size(); i++) {
        std::cout << i + 1 << ") " << terms[i] << '\n';
    }
}

int parse_entry(const std::string& entry, int max_number)
{
    int number = std::stoi(entry);
    if (number < 1 || number > max_number) {
        throw std::invalid_argument("");
    }

    return number;
}

std::string data_entry(const std::string& prompt, const std::vector<std::string>& terms)
{
    if (terms.empty()) {
        return "";
    }

    int choice;
    while (true) {
        print_menu(terms);
        std::cout << prompt;

        std::string entry;
        std::cin >> entry;

        try {
            choice = parse_entry(entry, terms.size());
            return terms[choice - 1];
        } catch (std::invalid_argument&) {
            // std::cout << "Not a valid menu entry!" << std::endl;
        }
    }
}

int main()
{
    std::vector<std::string> terms = {"fee fie", "huff and puff", "mirror mirror", "tick tock"};
    std::cout << "You chose: " << data_entry("> ", terms) << std::endl;
}
