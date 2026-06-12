/*
Compile with:
g++ -std=c++20 ChronologicalOrder.cpp -o ChronologicalOrder

This program reads event data from text files, extracts year information
(including BCE/CE era), sorts events chronologically, and prints them.
*/

#include <algorithm>
#include <fstream>
#include <iostream>
#include <regex>
#include <string>
#include <vector>

// Structure to represent a historical event with a label and year
struct Event {
    std::string label;  // Full text line describing the event
    int year;           // Numeric year value (negative for BCE, positive for CE)

    // Overload less-than operator for sorting events by year
    // Enables `std::sort` to arrange events chronologically
    bool operator<(const Event& other) const {
        return year < other.year;
    }
};

// Reads a file and extracts events with year information
// Returns a vector of `Event` objects sorted by extracted year value
std::vector<Event> getItemsByFile(const std::string& filename) {
    // Regex pattern to match: digits followed by space and era (CE or BCE)
    // Group 1: Full match, Group 2: Year digits, Group 3: Era (CE or BCE)
    const std::regex pattern{"((\\d+) +(B?CE))"};
    std::smatch matches;

    // Open file for reading
    std::ifstream stream{filename, std::ios::in};
    std::string currentLine;
    std::vector<Event> vec{};

    // Read file line by line
    while (std::getline(stream, currentLine)) {
        // Check if line contains a year pattern (e.g., "450 BCE" or "2023 CE")
        if (std::regex_search(currentLine, matches, pattern)) {
            // Extract year as integer from regex match group 2
            int year = std::stoi(matches[2].str());
            // Extract era designation from regex match group 3
            std::string era = matches[3].str();

            // Convert to sortable numeric value:
            // CE years remain positive, BCE years become negative
            // This ensures correct chronological ordering (BCE before CE)
            int sortValue = (era == "CE") ? year : -year;

            // Create `Event` with original line as label and calculated sort value
            vec.push_back(Event{currentLine, sortValue});
        }
    }

    return vec;
}

// Prints all event labels to standard output, one per line
void printItems(const std::vector<Event>& items) {
    for (const auto& item : items)
        std::cout << item.label << "\n";
}

int main() {
    // Load events from three input files
    auto items = getItemsByFile("table.txt");
    auto stretch = getItemsByFile("table2.txt");
    auto stretch2 = getItemsByFile("table3.txt");

    // Sort both event lists chronologically using the overloaded < operator
    std::sort(items.begin(), items.end());
    std::sort(stretch.begin(), stretch.end());
    std::sort(stretch2.begin(), stretch2.end());

    // Print sorted events from first file
    printItems(items);
    std::cout << "\n";  // Add blank line separator between file outputs
    // Print sorted events from second file
    printItems(stretch);
    std::cout << "\n";  // Add blank line separator between file outputs
    // Print sorted events from third file
    printItems(stretch2);

    return 0;
}
