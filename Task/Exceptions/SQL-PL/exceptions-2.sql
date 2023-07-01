BEGIN
 SIGNAL SQLSTATE '75002'
   SET MESSAGE_TEXT = 'Customer number is not known';
END @
