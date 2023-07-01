VAR
  l: Files.Locator;
BEGIN
  (* Locator is the directory *)
  l := Files.dir.This("proof");
  (* delete 'xx.txt' file, in directory 'proof'  *)
  Files.dir.Delete(l,"xx.txt");
END ...
