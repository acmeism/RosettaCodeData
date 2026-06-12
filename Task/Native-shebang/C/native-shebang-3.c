/*
 * rosettacode.org: Native shebang
 *
 * Copyright 2015, Jim Fougeron.  Code placed in public domain. If you
 * use this, please provide attribution to author. Code originally came
 * from the code found on rosettacode.org/wiki/Native_shebang, however
 * the code was about 80% rewritten.  But the logic of the compile()
 * function still strongly is based upon original code, and is a key
 * part of the file.
 *
 * Native C language shebang scripting. Build this program to /usr/local/bin
 * using:
 *    gcc -o/usr/local/bin/script_gcc script_gcc.c
 *
 * The name of the executable: "script_gcc" IS critical. It is used in knowing
 * that we have have found the proper shebang file when parsing commandline
 *
 * the actual shebang for executable C source scripts is:

#!/usr/local/bin/script_gcc [extra compile/link options]

 * If there additional lib's needed by your source file, then add the proper
 * params to the shebang line. So for instance if gmp, openssl, and zlib
 * were needed (and an additional include path), you would use this shebang:

 #!/usr/local/bin/script_gcc -lgmp -lssl -lcrypto -lz -I/usr/local/include

 * NOTE, we leak strdup calls, but they are 1 time leaks, and this process
 * will simply exec another process, so we ignore them.
 */

#include <errno.h>
#include <libgen.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

#define shebangNAME "script_gcc"
#define CC          "gcc"
#define CC_OPTS     "-lm -x c"
#define IEXT        ".c"
#define OEXT        ".out"

/* return time of file modification. If file does not exit, return 0
 * so that if we compare, it will always be older, and will be built */
time_t modtime(const char *filename) {
  struct stat st;

  if(stat(filename, &st) != EXIT_SUCCESS)
    return 0;
  return st.st_mtime;
}
/* join a pair of strings */
char *sjoin(const char *s1, const char *s2){
  char buf[BUFSIZ];

  if (!s1) s1=""; if (!s2) s2="";
  snprintf(buf, sizeof(buf), "%s%s", s1, s2);
  return strdup(buf);
}
/* compiles the original script file. It skips the first line (the shebang)
 * and compiles using "gcc .... -x c -" which avoids having to write a temp
 * source file (minus the shebang), we instead pipe source to gcc */
int compile(const char *srcpath, const char *binpath, const char *ex_comp_opts) {
  char buf[BUFSIZ];
  FILE *fsrc, *fcmp;

  sprintf(buf, "%s %s %s -o %s -", CC, CC_OPTS, ex_comp_opts, binpath);
  fsrc=fopen(srcpath, "r");
  if (!fsrc) return -1;
  fcmp=popen(buf, "w"); /* open up our gcc pipe to send it source */
  if (!fcmp) { fclose(fsrc); return -1; }

   /* skip shebang line, then compile rest of the file. */
  fgets(buf, sizeof(buf), fsrc);
  fgets(buf, sizeof(buf), fsrc);
  while (!feof(fsrc)) {
    fputs(buf, fcmp); /* compile this line of source with gcc */
    fgets(buf, sizeof(buf), fsrc);
  }
  fclose(fsrc);
  return pclose(fcmp);
}

/* tries to open the file 'argv0'. If we can open that file we read first line
 * and make SURE it is a script_gcc file. If it is a script_gcc file, we
 * look for any extra params for the compiler (params to the shebang line)
 * and if we find them, they are returned in ex_comp_opts.
 * return 0 if this is NOT a shebang file, return 1 if it IS the shebang file.
 */
int load_shebangline(const char *argv0, char **ex_comp_opts) {
  char opt[BUFSIZ], *cp;
  FILE *in = fopen(argv0, "r");

  if (!in) return 0;
  fgets(opt, sizeof(opt), in);
  fclose(in);
  /* ok, we found a readable file, but IS it our shebang file? */
  strtok(opt, "\r\n");
  if (strncmp(opt, "#!", 2) || !strstr(opt, shebangNAME))
    return 0; /* nope, keep looking */
  cp = strstr(opt, shebangNAME)+strlen(shebangNAME);
  if (*cp) /* capture compiler extra params, if any */
    *ex_comp_opts = strdup(cp);
  return 1;
}

/* NOTE, the argv[] array is different than 'normal' C programs.  argv[0] is
 * the shebang exe file. then argv[1] ... argv[p] are the params that follow
 * the shebang script name (from line1 of the script file). NOTE, some systems
 * (Linux, cygwin), will pack all of these options into argv[1] with spaces.
 * There is NO 'standard' on exactly what the layout it of these shebang params
 * may be, we only know that there will be 0 or more params BEFORE the script
 * name (which is the argv[0] we normally 'expect). Then argv[p+1] is the name
 * of script being run. NOTE if there are no shebang args, argv[1] will be
 * the script file name.  The script file name is our expected argv[0], and
 * all the params following that are the normal argv[1]...argv[n] we expect.
 */
int main(int argc, char *const argv[]) {
  int i;
  char exec_path[BUFSIZ], *argv0_basename, *ex_comp_opts=0, **dir,
  *paths[] = {
    NULL, /* paths[0] will be filled in later, to dir of the script */
    "/usr/local/bin",
    sjoin(getenv("HOME"), "/bin"),
    sjoin(getenv("HOME"), "/tmp"),
    getenv("HOME"),
    sjoin(getenv("HOME"), "/Desktop"),
    /* . and /tmp removed due to security concerns
    ".",
    "/tmp", */
    NULL
  };

  /* parse args, looking for the one that is the script. This would have been argv[0] if not exec'd as a shebang */
  for (i = 1; i < argc; ++i) {
    if (load_shebangline(argv[1], &ex_comp_opts)) {
      argc -= i;
      i = 0;
      break;
    }
    ++argv;
  }
  if (i)
    return !fprintf(stderr, "could not locate proper %s shebang file!!\n", shebangNAME) | ENOENT;
  ++argv;
  /* found it.  Now argv[0] is the 'script' name, and rest of argv[] is params to the script */
  argv0_basename = basename(strdup(argv[0]));
  paths[0] = dirname(strdup(argv[0]));
  /* find a cached version of the script, and if we find it, run it */
  for(dir = paths; *dir; dir++) {
    snprintf(exec_path, sizeof(exec_path), "%s/%s%s", *dir, argv0_basename, OEXT);
    if(modtime(exec_path) >= modtime(argv[0]))
      execvp(exec_path, argv); /* found a newer cached compiled file. Run it */
  }
  /* no cached file, or script is newer. So find a writeable dir */
  for(dir = paths; *dir; dir++) {
    if(!access(*dir, W_OK))
      break;
  }
  if (!*dir)
    return !fprintf(stderr, "No writeable directory for compile of the script %s\n", argv[0]) | EACCES;
  /* compile and exec the result from our C script source file */
  snprintf(exec_path, sizeof(exec_path), "%s/%s%s", *dir, argv0_basename, OEXT);
  if(!compile(argv[0], exec_path, ex_comp_opts))
    execvp(exec_path, argv);
  return !fprintf(stderr, "%s : executable not available\n", exec_path) | ENOENT;
}
