#include <string>
#include <ranges>
#include <iostream>
int main() {
    std::string s = "Hello,How,Are,You,Today";
    s = s                               // Assign the final string back to the string variable
      | std::views::split(',')          // Produce a range of the comma separated words
      | std::views::join_with('.')      // Concatenate the words into a single range of characters
      | std::ranges::to<std::string>(); // Convert the range of characters into a regular string
    std::cout << s;
}
