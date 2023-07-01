PROC copy file v1 = (STRING in name, out name)VOID: (
  # note: algol68toc-1.18 - can compile, but not run v1 #
  INT errno;
  FILE in file, out file;
  errno := open(in  file, in  name, stand in  channel);
  errno := open(out file, out name, stand out channel);

  BOOL in ended := FALSE;
  PROC call back ended = (REF FILE f) BOOL: in ended := TRUE;
  on logical file end(in file, call back ended);

  STRING line;
  WHILE
    get(in  file, (line, new line));
# WHILE # NOT in ended DO # break to avoid excess new line #
    put(out file, (line, new line))
  OD;
ended:
  close(in  file);
  close(out file)
);

PROC copy file v2 = (STRING in name, out name)VOID: (
  INT errno;
  FILE in file, out file;
  errno := open(in file, in name, stand in channel);
  errno := open(out file, out name, stand out channel);

  PROC call back ended = (REF FILE f) BOOL: GO TO done;
  on logical file end(in file, call back ended);

  STRING line;
  DO
    get(in  file, line);
    put(out file, line);
    get(in  file, new line);
    put(out file, new line)
  OD;
done:
  close(in file);
  close(out file)
);

test:(
  copy file v2("input.txt","output.txt")
)
