PROC pi = (INT throws)REAL:
BEGIN
   INT inside := 0;
   TO throws DO
      IF random ** 2 + random ** 2 <= 1 THEN
         inside +:= 1
      FI
   OD;
   4 * inside / throws
END # pi #;

print (("     10 000:",pi (     10 000),new line));
print (("    100 000:",pi (    100 000),new line));
print (("  1 000 000:",pi (  1 000 000),new line));
print ((" 10 000 000:",pi ( 10 000 000),new line));
print (("100 000 000:",pi (100 000 000),new line))
