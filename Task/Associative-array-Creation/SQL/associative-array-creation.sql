REM Create a table to associate keys with values
CREATE TABLE  associative_array ( KEY_COLUMN VARCHAR2(10), VALUE_COLUMN VARCHAR2(100)); .
REM Insert a Key Value Pair
INSERT (KEY_COLUMN, VALUE_COLUMN) VALUES ( 'VALUE','KEY');.
REM Retrieve a key value pair
SELECT aa.value_column FROM associative_array aa where aa.key_column = 'KEY';
