#!/usr/local/bin/a68g --script #

program caesar: BEGIN

   MODE MODXXVI = SHORT SHORT INT; # MOD26 #

   PROC to m26 = (CHAR c, offset)MODXXVI:
   BEGIN
      ABS c - ABS offset
   END #to m26#;

   PROC to char = (MODXXVI value, CHAR offset)CHAR:
   BEGIN
      REPR ( ABS offset + value MOD 26 )
   END #to char#;

   PROC encrypt = (STRING plain, MODXXVI key)STRING:
   BEGIN
      [UPB plain]CHAR ciph;
      FOR i TO UPB plain DO
         CHAR c = plain[i];
         ciph[i]:=
           IF "A" <= c AND c <= "Z" THEN
               to char(to m26(c, "A")+key, "A")
           ELIF "a" <= c AND c <= "z" THEN
               to char(to m26(c, "a")+key, "a")
           ELSE
               c
           FI
      OD;
      ciph
   END #encrypt#;

# caesar main program #
   STRING text := "The five boxing wizards jump quickly" # OR read string #;
   MODXXVI key := 3; # Default key from "Bello Gallico" #

   printf(($gl$, "Plaintext ------------>" + text));
   text := encrypt(text, key);
   printf(($gl$, "Ciphertext ----------->" + text));
   printf(($gl$, "Decrypted Ciphertext ->" + encrypt(text, -key)))

END #caesar#
