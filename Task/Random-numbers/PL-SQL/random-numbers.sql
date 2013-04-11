create or replace
PROCEDURE PROCEDURE1 AS
    TYPE numsColl is TABLE OF NUMBER;
    nums numsColl;

    FUNCTION GenNums(n IN NUMBER) RETURN numsColl AS
        PI NUMBER := ACOS (-1);
    BEGIN
        nums := numsColl();
        nums.extend(n);

        FOR i in 1 .. n LOOP
            nums(i) := 1 + .5 * (sqrt(-2 * log(dbms_random.value, 10)) * cos(2 * PI * dbms_random.value));
        END LOOP;

        RETURN nums;
    END GenNums;

BEGIN
    nums := GenNums(10);
    FOR i in 1 .. 10 LOOP
        DBMS_OUTPUT.PUT_LINE(nums(i));
    END LOOP;
END PROCEDURE1;
