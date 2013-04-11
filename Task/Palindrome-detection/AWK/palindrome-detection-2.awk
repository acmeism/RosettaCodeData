function is_palindro_r(s)
{
  if ( length(s) < 2 ) return 1;
  if ( substr(s, 1, 1) != substr(s, length(s), 1) ) return 0;
  return is_palindro_r(substr(s, 2, length(s)-2))
}
