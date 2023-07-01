def stripchars(string; banish):
  (string | explode) - (banish | explode) | implode;
