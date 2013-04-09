LOGICAL :: file_exists
INQUIRE(FILE="input.txt", EXIST=file_exists)   ! file_exists will be TRUE if the file
                                               ! exists and FALSE otherwise
INQUIRE(FILE="/input.txt", EXIST=file_exists)
