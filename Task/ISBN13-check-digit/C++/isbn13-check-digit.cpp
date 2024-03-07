#include <iostream>

bool check_isbn13(std::string isbn) {
    int count = 0;
    int sum = 0;

    for (auto ch : isbn) {
        /* skip hyphens or spaces */
        if (ch == ' ' || ch == '-') {
            continue;
        }
        if (ch < '0' || ch > '9') {
            return false;
        }
        if (count & 1) {
            sum += 3 * (ch - '0');
        } else {
            sum += ch - '0';
        }
        count++;
    }

    if (count != 13) {
        return false;
    }
    return sum % 10 == 0;
}

int main() {
    auto isbns = { "978-0596528126", "978-0596528120", "978-1788399081", "978-1788399083" };
    for (auto isbn : isbns) {
        std::cout << isbn << ": " << (check_isbn13(isbn) ? "good" : "bad") << '\n';
    }

    return 0;
}
