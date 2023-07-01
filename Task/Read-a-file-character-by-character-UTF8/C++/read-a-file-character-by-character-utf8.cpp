#include <fstream>
#include <iostream>
#include <locale>

using namespace std;

int main(void)
{
    /* If your native locale doesn't use UTF-8 encoding
     * you need to replace the empty string with a
     * locale like "en_US.utf8"
     */
    std::locale::global(std::locale("")); // for C++
    std::cout.imbue(std::locale());
    ifstream in("input.txt");

    wchar_t c;
    while ((c = in.get()) != in.eof())
        wcout<<c;
    in.close();

    return EXIT_SUCCESS;
}
