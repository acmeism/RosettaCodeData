DATA DIVISION.
WORKING-STORAGE SECTION.
01  initialized-data      PIC X(15) VALUE "Hello, World!".
01  other-data            PIC X(15).
...
PROCEDURE DIVISION.
    DISPLAY initialized-data *> Shows 'Hello, World!'
    DISPLAY other-data       *> Will probably show 15 spaces.
    ...
    *> Sets initialized-data back to "Hello, World!" and fills other-data with spaces.
    INITIALIZE initialized-data, other-data
