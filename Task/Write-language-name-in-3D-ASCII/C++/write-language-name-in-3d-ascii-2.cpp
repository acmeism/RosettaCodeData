// @author Martin Ettl (http://www.martinettl.de)
// @date   2013-07-26
// A program to print the letters 'CPP' in 3D ASCII-art.

#include <iostream>
#include <string>

int main()
{
    std::string strAscii3D =
        "  /$$$$$$  /$$$$$$$  /$$$$$$$ \n"
        " /$$__  $$| $$__  $$| $$__  $$\n"
        "| $$  \\__/| $$  \\ $$| $$  \\ $$\n"
        "| $$      | $$$$$$$/| $$$$$$$/\n"
        "| $$      | $$____/ | $$____/ \n"
        "| $$    $$| $$      | $$      \n"
        "|  $$$$$$/| $$      | $$      \n"
        " \\______/ |__/      |__/  \n";

    std::cout << "\n" << strAscii3D << std::endl;

    return 0;
}
