#include <cstdio>

int main()
{
    std::rename("input.txt", "output.txt");
    std::rename("docs", "mydocs");
    std::rename("/input.txt", "/output.txt");
    std::rename("/docs", "/mydocs");
    return 0;
}
