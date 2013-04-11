PROC number words = (INT n)STRING:(
  # returns a string representation of n in words. Currently
  deals with anything from 0 to 999 999 999. #
    []STRING digits = []STRING
      ("zero","one","two","three","four","five","six","seven","eight","nine")[@0];
    []STRING teens = []STRING
      ("ten","eleven","twelve","thirteen","fourteen","fifteen","sixteen","seventeen","eighteen","nineteen")[@0];
    []STRING decades = []STRING
      ("twenty","thirty","forty","fifty","sixty","seventy","eighty","ninety")[@2];

    PROC three digits = (INT n)STRING: (
      # does the conversion for n from 0 to 999. #
        INT tens = n MOD 100 OVER 10;
        INT units = n MOD 10;
        (n >= 100|digits[n OVER 100] + " " + "hundred" + (n MOD 100 /= 0|" and "|"")|"") +
        (tens /= 0|(tens = 1|teens[units]|decades[tens] + (units /= 0|"-"|""))|"") +
        (units /= 0 AND tens /= 1 OR n = 0|digits[units]|"")
      );
    INT m = n OVER 1 000 000;
    INT k = n MOD 1 000 000 OVER 1000;
    INT u = n MOD 1000;
    (m /= 0|three digits(m) + " million"|"") +
    (m /= 0 AND (k /= 0 OR u >= 100)|", "|"") +
    (k /= 0|three digits(k) + " thousand"|"") +
    ((m /= 0 OR k /= 0) AND u > 0 AND u < 100|" and " |: k /= 0 AND u /= 0|", "|"") +
    (u /= 0 OR n = 0|three digits(u)|"")
  );

on logical file end(stand in, (REF FILE f)BOOL: GOTO stop iteration);
on value error(stand in, (REF FILE f)BOOL: GOTO stop iteration);
DO # until user hits EOF #
  INT n;
  print("n? ");
  read((n, new line));
  print((number words(n), new line))
OD;
stop iteration:
  SKIP
