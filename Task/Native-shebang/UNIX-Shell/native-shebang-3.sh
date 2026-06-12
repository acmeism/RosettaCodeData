#!/usr/local/bin/script_gcc.sh
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
