-module(testvigenere).
-import(vigenere,[encrypt/2, decrypt/2]).
main(_) ->
  Key = "Vigenere cipher",
  CipherText = encrypt("Beware the Jabberwock, my son! The jaws that bite, the claws that catch!", Key),
  RecoveredText = decrypt(CipherText, Key),
  io:fwrite("Ciphertext: ~s~nDecrypted:  ~s~n", [CipherText, RecoveredText]).
