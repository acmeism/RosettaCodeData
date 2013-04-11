main:(
  PROC rename = (STRING source name, dest name)INT:
  BEGIN
    FILE actual file;
    INT errno = open(actual file, source name, stand back channel);
    IF errno NE 0 THEN
      errno
    ELSE
      IF reidf possible(actual file) THEN
        reidf(actual file, dest name); # change the identification of the book #
        errno
      ELSE
        close(actual file);
        -1
      FI
    FI
  END;
  rename("input.txt", "output.txt");
  rename("/input.txt", "/output.txt");
  rename("docs", "mydocs");
  rename("/docs", "/mydocs")
)
