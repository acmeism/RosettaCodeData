-- Let's create a generic class with one method to be used as an interface:
create or replace
TYPE callback AS OBJECT (
    -- A class needs at least one member even though we don't use it
    -- There's no generic OBJECT type, so let's call it NUMBER
    dummy NUMBER,
    -- Here's our function, and since PL/SQL doesn't have generics,
    -- let's use type NUMBER for our params
    MEMBER FUNCTION exec(n number) RETURN number
) NOT FINAL not instantiable;
/

-- Now let's inherit from that, defining a class with one method. We'll have ours square a number.
-- We can pass this class into any function that takes type callback:
CREATE OR REPLACE TYPE CB_SQUARE under callback (
    OVERRIDING MEMBER FUNCTION exec(n NUMBER) RETURN NUMBER
)
/
CREATE OR REPLACE
TYPE BODY CB_SQUARE AS
    OVERRIDING MEMBER FUNCTION exec(n NUMBER) RETURN NUMBER IS
    BEGIN
        RETURN n * n;
    END exec;
END;
/

-- And a package to hold our test
CREATE OR REPLACE
PACKAGE PKG_CALLBACK AS
    myCallback cb_square;
    TYPE intTable IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
    ints intTable;
    i PLS_INTEGER;

    procedure test_callback;
END PKG_CALLBACK;
/

CREATE OR REPLACE PACKAGE BODY PKG_CALLBACK AS
    -- Our generic mapping function that takes a "method" and a collection
    -- Note that it takes the generic callback type
    -- that doesn't know anything about squaring
    procedure do_callback(myCallback IN callback, ints IN OUT intTable) IS
        i PLS_INTEGER;
        myInt NUMBER;
    begin
        for i in 1 .. ints.count loop
            myInt := ints(i);
            -- PL/SQL call's the child's method
            ints(i) := myCallback.exec(myInt);
        END LOOP;
    end do_callback;

    procedure test_callback IS
    BEGIN
        myCallback := cb_square(null);
        FOR i IN 1..5 LOOP
            ints(i) := i;
        END LOOP;

        do_callback(myCallback, ints);

        i := ints.FIRST;
        WHILE i IS NOT NULL LOOP
            DBMS_OUTPUT.put_line(ints(i));
            i := ints.next(i);
        END LOOP;
    END test_callback;
END PKG_CALLBACK;
/

BEGIN
  PKG_CALLBACK.TEST_CALLBACK();
END;
/
