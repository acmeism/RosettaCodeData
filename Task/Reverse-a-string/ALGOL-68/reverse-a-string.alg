PROC reverse = (REF STRING s)VOID:
  FOR i TO UPB s OVER 2 DO
    CHAR c = s[i];
    s[i] := s[UPB s - i + 1];
    s[UPB s - i + 1] := c
  OD;

main:
(
  STRING text := "Was it a cat I saw";
  reverse(text);
  print((text, new line))
)
