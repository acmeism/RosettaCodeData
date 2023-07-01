--#SET TERMINATOR @

SET SERVEROUTPUT ON @

BEGIN
 DECLARE TYPE ASSOC_ARRAY AS VARCHAR(20) ARRAY [VARCHAR(20)];
 DECLARE HASH ASSOC_ARRAY;
 SET HASH['key1'] = 'val1';
 SET HASH['key-2'] = 2;
 SET HASH['three'] = -238.83;
 SET HASH[4] = 'val3';

 CALL DBMS_OUTPUT.PUT_LINE(HASH['key1']);
 CALL DBMS_OUTPUT.PUT_LINE(HASH['key-2']);
 CALL DBMS_OUTPUT.PUT_LINE(HASH['three']);
 CALL DBMS_OUTPUT.PUT_LINE(HASH[4]);
 CALL DBMS_OUTPUT.PUT_LINE(HASH['5']);
END@