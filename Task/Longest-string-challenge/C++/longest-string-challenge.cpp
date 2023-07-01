#include <iostream>
#include <string.h>

int main()
{
    std::string longLine, longestLines, newLine;

    while (std::cin >> newLine)
    {
        auto isNewLineShorter = longLine.c_str();
        auto isLongLineShorter = newLine.c_str();
        while (*isNewLineShorter && *isLongLineShorter)
        {
            // This determines which string is longer without using a built
            // in string length function.  The loop will stop at the 0 at the
            // end of the shortest string.
            isNewLineShorter = &isNewLineShorter[1];
            isLongLineShorter = &isLongLineShorter[1];
        }

        if(*isNewLineShorter) continue; // other lines were longer, do nothing
        if(*isLongLineShorter)
        {
            // the new string is the longest so far
            longLine = newLine;
            longestLines = newLine;
        }
        else
        {
            // the new string is the same lenth as the previous longest
            longestLines+=newLine;
        }
        longestLines+="\n"; // append a new line between the strings
    }

    std::cout << "\nLongest string:\n" << longestLines;
}
