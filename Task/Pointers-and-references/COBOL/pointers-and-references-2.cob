01  heap-item PICTURE IS X, BASED.

PROCEDURE DIVISION.
    ALLOCATE heap-item RETURNING ptr
    *> ...
    FREE ptr
