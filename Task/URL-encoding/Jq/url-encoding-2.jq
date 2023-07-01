def url_encode:
   # The helper function checks whether the input corresponds to one of the characters: !'()*
   def recode: . as $c | [33,39,40,41,42] | index($c);
   def hex:   if . < 10 then 48 + . else  55 + . end;
   @uri
   | explode
   # 37 ==> "%", 50 ==> "2"
   | map( if recode then (37, 50, ((. - 32) | hex)) else . end )
   | implode;
