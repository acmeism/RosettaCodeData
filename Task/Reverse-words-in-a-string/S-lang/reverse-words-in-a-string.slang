variable ln, in =
  ["---------- Ice and Fire ------------",
   "fire, in end will world the say Some",
   "ice. in say Some",
   "desire of tasted I've what From",
   "fire. favor who those with hold I",
   "",
   "... elided paragraph last ...",
   "",
   "Frost Robert -----------------------"];

foreach ln (in) {
  ln = strtok(ln, " \t");
  array_reverse(ln);
  () = printf("%s\n", strjoin(ln, " "));
}
