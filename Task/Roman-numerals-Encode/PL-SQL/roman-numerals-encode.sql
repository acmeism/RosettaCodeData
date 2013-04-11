/*****************************************************************
 * $Author: Atanas Kebedjiev $
 *****************************************************************
 * Encoding an Arabic numeral to a Roman in the range 1..3999 is much simpler as Oracle provides the conversion formats.
 * Please see also the SQL solution for the same task.
 */

DECLARE
FUNCTION rencode(an IN NUMBER) RETURN VARCHAR2 IS
   rs VARCHAR2(20);
BEGIN
SELECT to_char(to_char(to_date(an,'YYYY'), 'RRRR'), 'RN') INTO rs FROM dual;
RETURN rs;
END;

BEGIN

    DBMS_OUTPUT.PUT_LINE ('2012 = ' || rencode('2012'));     -- MMXII
    DBMS_OUTPUT.PUT_LINE ('1951 = ' || rencode('1951'));     -- MCMLI
    DBMS_OUTPUT.PUT_LINE ('1987 = ' || rencode('1987'));     -- MCMLXXXVII
    DBMS_OUTPUT.PUT_LINE ('1666 = ' || rencode('1666'));     -- MDCLXVI
    DBMS_OUTPUT.PUT_LINE ('1999 = ' || rencode('1999'));     -- MCMXCIX

END;
