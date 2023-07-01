/*****************************************************************
 * $Author: Atanas Kebedjiev $
 *****************************************************************
 * PL/SQL code can be run as anonymous block.
 * To test, execute the whole script or create the functions and then e.g. 'select rdecode('2012') from dual;
 * Please note that task definition does not describe fully some current rules, such as
 * * subtraction - IX XC CM are the valid subtraction combinations
 * * A subtraction character cannot be repeated: 8 is expressed as VIII and not as IIX
 * * V L and D cannot be used for subtraction
 * * Any numeral cannot be repeated more than 3 times: 1910 should be MCMX and not MDCCCCX
 * Code below does not validate the Roman numeral itself and will return a result even for a non-compliant number
 * E.g. both MCMXCIX and IMM will return 1999 but the first one is the correct notation
 */

DECLARE

FUNCTION rvalue(c IN CHAR) RETURN NUMBER IS
    i INTEGER;
BEGIN
    i := 0;
    CASE (c)
        when 'M' THEN i := 1000;
        when 'D' THEN i := 500;
        when 'C' THEN i := 100;
        when 'L' THEN i := 50;
        when 'X' THEN i := 10;
        when 'V' THEN i := 5;
        when 'I' THEN i := 1;
    END CASE;
    RETURN i;
END;


FUNCTION decode(rn IN VARCHAR2) RETURN NUMBER IS
   i  INTEGER;
   l  INTEGER;
   cr CHAR;   -- current Roman numeral as substring from r
   cv INTEGER; -- value of current Roman numeral

   gr CHAR;   -- next Roman numeral
   gv NUMBER; --  value of the next numeral;

   dv NUMBER; -- decimal value to return
BEGIN
           l := length(rn);
           i := 1;
           dv := 0;
           while (i <= l)
           LOOP
                cr := substr(rn,i,1);
                cv := rvalue(cr);

   /* Look for a larger numeral in next position, like IV or CM
      The number to subtract should be at least 1/10th of the bigger number
      CM and XC are valid, but IC and XM are not */
                IF (i < l) THEN
                   gr := substr(rn,i+1,1);
                   gv := rvalue(gr);
                   IF (cv < gv ) THEN
                      dv := dv - cv;
                   ELSE
                      dv := dv + cv;
                   END IF;
                ELSE
                   dv := dv + cv;
                END IF;  -- need to add the last value unconditionally

                i := i + 1;
            END LOOP;

RETURN dv;

END;

BEGIN

    DBMS_OUTPUT.PUT_LINE ('MMXII      = ' || rdecode('MMXII'));       -- 2012
    DBMS_OUTPUT.PUT_LINE ('MCMLI      = ' || rdecode('MCMLI'));       -- 1951
    DBMS_OUTPUT.PUT_LINE ('MCMLXXXVII = ' || rdecode('MCMLXXXVII'));  -- 1987
    DBMS_OUTPUT.PUT_LINE ('MDCLXVI    = ' || rdecode('MDCLXVI'));     -- 1666
    DBMS_OUTPUT.PUT_LINE ('MCMXCIX    = ' || rdecode('MCMXCIX'));     -- 1999

END;
