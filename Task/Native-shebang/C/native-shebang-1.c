#!/usr/local/bin/script_gcc.sh
/* Optional: this C code initially is-being/can-be boot strapped (compiled) using bash script_gcc.sh */
#include <errno.h>
#include <libgen.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

/* the actual shebang for C target scripts is:
#!/usr/local/bin/script_gcc.c
*/

/* general readability constants */
typedef char /* const */ *STRING;
typedef enum{FALSE=0, TRUE=1} BOOL;
const STRING ENDCAT = NULL;

/* script_gcc.c specific constants */
#define DIALECT "c" /* or cpp */
const STRING
  CC="gcc",
  COPTS="-lm -x "DIALECT,
  IEXT="."DIALECT,
  OEXT=".out";
const BOOL OPT_CACHE = TRUE;

/* general utility procedured */
char strcat_out[BUFSIZ];

STRING STRCAT(STRING argv, ... ){
  va_list ap;
  va_start(ap, argv);
  STRING arg;
  strcat_out[0]='\0';
  for(arg=argv; arg != ENDCAT; arg=va_arg(ap, STRING)){
     strncat(strcat_out, arg, sizeof strcat_out);
  }
  va_end(ap);
  return strndup(strcat_out, sizeof strcat_out);
}

char itoa_out[BUFSIZ];

STRING itoa_(int i){
  sprintf(itoa_out, "%d", i);
  return itoa_out;
}

time_t modtime(STRING filename){
  struct stat buf;
  if(stat(filename, &buf) != EXIT_SUCCESS)perror(filename);
  return buf.st_mtime;
}

/* script_gcc specific procedure */
BOOL compile(STRING srcpath, STRING binpath){
  int out;
  STRING compiler_command=STRCAT(CC, " ", COPTS, " -o ", binpath, " -", ENDCAT);
  FILE *src=fopen(srcpath, "r"),
       *compiler=popen(compiler_command, "w");
  char buf[BUFSIZ];
  BOOL shebang;

  for(shebang=TRUE; fgets(buf, sizeof buf, src); shebang=FALSE)
    if(!shebang)fwrite(buf, strlen(buf), 1, compiler);

  out=pclose(compiler);
  return out;
}

void main(int argc, STRING *argv, STRING *envp){

  STRING binpath,
         srcpath=argv[1],
         argv0_basename=STRCAT(basename((char*)srcpath /*, .DIALECT */), ENDCAT),
         *dirnamew, *dirnamex;
  argv++; /* shift */

/* Warning: current dir "." is in path, AND * /tmp directories are common/shared */
  STRING paths[] = {
    dirname(strdup(srcpath)), /* not sure why strdup is required? */
    STRCAT(getenv("HOME"), "/bin", ENDCAT),
    "/usr/local/bin",
    ".",
    STRCAT(getenv("HOME"), "/tmp", ENDCAT),
    getenv("HOME"),
    STRCAT(getenv("HOME"), "/Desktop", ENDCAT),
/*  "/tmp" ... a  bit of a security hole */
    ENDCAT
  };

  for(dirnamew = paths; *dirnamew; dirnamew++){
    if(access(*dirnamew, W_OK) == EXIT_SUCCESS) break;
  }

/* if a CACHEd copy is not to be kept, then fork a sub-process to unlink the .out file */
  if(OPT_CACHE == FALSE){
    binpath=STRCAT(*dirnamew, "/", argv0_basename, itoa_(getpid()), OEXT, ENDCAT);
    if(compile(srcpath, binpath) == EXIT_SUCCESS){
      if(fork()){
        sleep(0.1); unlink(binpath);
      } else {
        execvp(binpath, argv);
      }
    }
  } else {
/* else a CACHEd copy is kept, so find it */
    time_t modtime_srcpath = modtime(srcpath);
    for(dirnamex = paths; *dirnamex; dirnamex++){
      binpath=STRCAT(*dirnamex, "/", argv0_basename, OEXT, ENDCAT);
      if((access(binpath, X_OK) == EXIT_SUCCESS) && (modtime(binpath) >= modtime_srcpath))
        execvp(binpath, argv);
    }
  }

  binpath=STRCAT(*dirnamew, "/", argv0_basename, OEXT, ENDCAT);
  if(compile(srcpath, binpath) == EXIT_SUCCESS)
    execvp(binpath, argv);

  perror(STRCAT(binpath, ": executable not available", ENDCAT));
  exit(errno);
}
