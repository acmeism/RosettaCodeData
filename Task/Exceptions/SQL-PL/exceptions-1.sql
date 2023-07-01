--#SET TERMINATOR @

BEGIN
 DECLARE numerator INTEGER DEFAULT 12;
 DECLARE denominator INTEGER DEFAULT 0;
 DECLARE result INTEGER;
 DECLARE overflow CONDITION for SQLSTATE '22003' ;
 DECLARE CONTINUE HANDLER FOR overflow
   RESIGNAL SQLSTATE '22375'
   SET MESSAGE_TEXT = 'Zero division';
 IF denominator = 0 THEN
  SIGNAL overflow;
 ELSE
  SET result = numerator / denominator;
 END IF;
END @
