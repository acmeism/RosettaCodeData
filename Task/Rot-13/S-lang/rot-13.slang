variable old = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
variable new = "NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm";

define rot13(s) {
  s = strtrans(s, old, new);
  return s;
}

define rot13_stream(s) {
  variable ln;
  while (-1 != fgets(&ln, s))
    fputs(rot13(ln), stdout);
}

if (__argc > 1) {
  variable arg, fp;
  foreach arg (__argv[[1:]]) {
    fp = fopen(arg, "r");
    rot13_stream(fp);
  }
}
else
  rot13_stream(stdin);
