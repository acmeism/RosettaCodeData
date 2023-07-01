main:(
  PROC remove = (STRING file name)INT:
  BEGIN
    FILE actual file;
    INT errno = open(actual file, file name, stand back channel);
    IF errno NE 0 THEN stop remove FI;
    scratch(actual file); # detach the book and burn it #
    errno
  EXIT
  stop remove:
      errno
  END;
  remove("input.txt");
  remove("/input.txt");
  remove("docs");
  remove("/docs")
)
