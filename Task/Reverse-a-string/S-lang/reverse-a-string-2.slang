define init_unicode_array(a, buf)
{
  variable len = strbytelen(buf), ch, p0 = 0, p1 = 0;
  while (p1 < len) {
    (p1, ch) = strskipchar(buf, p1, 1);
    if (ch < 0) print("oops.");
    a[p0] = ch;
    p0++;
  }
}

variable su = "Σὲ γνωρίζω ἀπὸ τὴν κόψη";
variable au = Int_Type[strlen(su)+1];
init_unicode_array(au, su);
array_reverse(au);
% print(au);
print(strjoin(array_map(String_Type, &char, au), "") );
