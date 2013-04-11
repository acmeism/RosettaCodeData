#include <string>
#include <iostream>
#include <ostream>

void increment_numerical_string(std::string& s)
{
    std::string::reverse_iterator iter = s.rbegin(), end = s.rend();
    int carry = 1;
    while (carry && iter != end)
    {
        int value = (*iter - '0') + carry;
        carry = (value / 10);
        *iter = '0' + (value % 10);
        ++iter;
    }
    if (carry)
        s.insert(0, "1");
}

int main()
{
    std::string big_number = "123456789012345678901234567899";
    std::cout << "before increment: " << big_number << "\n";
    increment_numerical_string(big_number);
    std::cout << "after increment:  " << big_number << "\n";
}
