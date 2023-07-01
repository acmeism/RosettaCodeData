main:(

  INT errno;

  PROC touch = (STRING file name)INT:
  BEGIN
    FILE actual file;
    INT errno := open(actual file, file name, stand out channel);
    IF errno NE 0 THEN GO TO stop touch FI;
    close(actual file); # detach the book and keep it #
    errno
  EXIT
  stop touch:
      errno
  END;

  errno := touch("input.txt");
  errno := touch("/input.txt");

  # ALGOL 68 has no concept of directories,
    however a file can have multiple pages,
    the pages are identified by page number only #

  PROC mkpage = (STRING file name, INT page x)INT:
  BEGIN
    FILE actual file;
    INT errno := open(actual file, file name, stand out channel);
    IF errno NE 0 THEN GO TO stop mkpage FI;
    set(actual file,page x,1,1); # skip to page x, line 1, character 1 #
    close(actual file); # detach the new page and keep it #
    errno
  EXIT
  stop mkpage:
      errno
  END;

  errno := mkpage("input.txt",2);
)
