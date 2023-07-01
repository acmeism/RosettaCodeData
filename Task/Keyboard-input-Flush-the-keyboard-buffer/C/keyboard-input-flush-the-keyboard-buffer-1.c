#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[])
{
    // Get a chance to make stdin input buffer dirty.
    //
    char text[256];
    getchar();

    // This DOES NOT WORK properly on all modern systems including Linux & W10.
    // Obsolete, don't use this. BTW, there is no fpurge in MSVC libs in 2020.
    //
    // fflush(stdin);

    // Always works. Readed characters may remain somethere in RAM.
    //
    fseek(stdin, 0, SEEK_END);

    // A very dirty solution - an unbuffered stream does not need any flushing.
    //
    // setvbuf(stdin, NULL, _IONBF, 0);

    // Now we are able to check if the buffer is really empty.
    //
    fgets(text, sizeof(text), stdin);
    puts(text);

    return EXIT_SUCCESS;
}
