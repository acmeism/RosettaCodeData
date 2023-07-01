DECLARE
    i number := 5;
    divide_by_zero EXCEPTION;
    PRAGMA exception_init(divide_by_zero, -20000);
BEGIN
    DBMS_OUTPUT.put_line( 'startLoop' );
    <<startLoop>>
        BEGIN
            if i = 0 then
                raise divide_by_zero;
            end if;
            DBMS_OUTPUT.put_line( 100/i );
            i := i - 1;
            GOTO startLoop;
        EXCEPTION
        WHEN divide_by_zero THEN
            DBMS_OUTPUT.put_line( 'Oops!' );
            GOTO finally;
        END;
    <<endLoop>>
    DBMS_OUTPUT.put_line( 'endLoop' );

    <<finally>>
    DBMS_OUTPUT.put_line( 'Finally' );
END;
/
