SET serveroutput ON
CALL DBMS_OUTPUT.PUT_LINE('This is the first line.' || chr(10) ||
'This is the second line.' || chr(10) ||
'This is the third line.');
