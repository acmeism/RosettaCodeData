#!/usr/local/bin/script_gcc
/*
 * note, any additional libs or include paths would have params added after
 * the script_gcc parts of the shebang line, such as:
 * #!/usr/local/bin/script_gcc -lgmp -I/usr/local/include/gmp5
 */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char **argv, char **envp){
  char ofs = '\0';
  for(argv++; *argv; argv++){
    if(ofs)putchar(ofs); else ofs=' ';
    fwrite(*argv, strlen(*argv), 1, stdout);
  }
  putchar('\n');
  exit(EXIT_SUCCESS);
}
