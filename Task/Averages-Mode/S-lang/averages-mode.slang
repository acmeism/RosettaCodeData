private variable mx, mxkey, modedat;

define find_max(key) {
  if (modedat[key] > mx) {
    mx = modedat[key];
    mxkey = {key};
  }
  else if (modedat[key] == mx) {
    list_append(mxkey, key);
  }
}

define find_mode(indat)
{
  % reset [file/module-scope] globals:
  mx = 0, mxkey = {}, modedat = Assoc_Type[Int_Type, 0];

  foreach $1 (indat)
    modedat[string($1)]++;

  array_map(Void_Type, &find_max, assoc_get_keys(modedat));

  if (length(mxkey) > 1) {
    $2 = 0;
    () = printf("{");
    foreach $1 (mxkey) {
      () = printf("%s%s", $2 ? ", " : "", $1);
      $2 = 1;
    }
    () = printf("} each have ");
  }
  else
    () = printf("%s has ", mxkey[0], mx);
  () = printf("the most entries (%d).\n", mx);
}

find_mode({"Hungadunga", "Hungadunga", "Hungadunga", "Hungadunga", "McCormick"});

find_mode({"foo", "2.3", "bar", "foo", "foobar", "quality", 2.3, "strnen"});
