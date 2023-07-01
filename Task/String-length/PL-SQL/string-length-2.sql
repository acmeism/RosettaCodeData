DECLARE
  string VARCHAR2(50) := 'Hello, world!';
  stringlength NUMBER;
  unicodelength NUMBER;
  ucs2length NUMBER;
  ucs4length NUMBER;
BEGIN
  stringlength := LENGTH(string);
  unicodelength := LENGTHC(string);
  ucs2length := LENGTH2(string);
  ucs4length := LENGTH4(string);
END;
