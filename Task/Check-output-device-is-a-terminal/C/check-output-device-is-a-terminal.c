#include <unistd.h>   // for isatty()
#include <stdio.h>    // for fileno()

int main()
{
    puts(isatty(fileno(stdout))
          ? "stdout is tty"
          : "stdout is not tty");
    return 0;
}
