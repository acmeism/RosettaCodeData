def gamma_by_stirling:
  def pow(x): if x == 0 then 1 elif x == 1 then . else x * log | exp end;
  ((1|atan) * 8) as $twopi
  | . as $x
  | (($twopi/$x) | sqrt) * ( ($x / (1|exp)) | pow($x));
