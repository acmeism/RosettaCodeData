STRING key := "";

PROC vigenere cipher = (REF STRING key)VOID:
(
  FOR i FROM LWB key TO UPB key DO
    IF key[i] >= "A" AND key[i] <= "Z" THEN
      key +:= key[i] FI;
    IF key[i] >= "a" AND key[i] <= "z" THEN
      key +:= REPR(ABS key[i] + ABS"A" - ABS"a") FI
  OD
);

PROC encrypt = (STRING text)STRING:
(
  STRING out := "";

  INT j := LWB text;
  FOR i FROM LWB text TO UPB text DO
    CHAR c := text[i];

    IF c >= "a" AND c <= "z" THEN
      c := REPR(ABS c + (ABS"A" - ABS"a")) FI;
    IF c >= "A" AND c <= "Z" THEN
      out +:= REPR((ABS c + ABS key[j] - 2*ABS"A") MOD 26 + ABS"A");
      j := j MOD UPB key + 1
    FI
  OD;

  out
);

PROC decrypt = (STRING text)STRING:
(
  STRING out;

  INT j := LWB text;
  FOR i FROM LWB text TO UPB text DO
    CHAR c := text[i];

    IF c >= "a" AND c <= "z" THEN
      c := REPR(ABS c + (ABS"A" - ABS"a")) FI;
    IF c >= "A" AND c <= "Z" THEN
      out +:= REPR((ABS c - ABS key[j] + 26) MOD 26 + ABS"A");
      j := j MOD UPB key + 1
    FI
  OD;

  out
);

main:
(
  vigenere cipher(key:="VIGENERECIPHER");

  STRING original := "Beware the Jabberwock, my son! The jaws that bite, the claws that catch!";
  STRING encrypted := encrypt(original);
  STRING decrypted := decrypt(encrypted);

  print((original, new line));
  print(("Encrypted: ", encrypted, new line));
  print(("Decrypted: ", decrypted, new line))
)
