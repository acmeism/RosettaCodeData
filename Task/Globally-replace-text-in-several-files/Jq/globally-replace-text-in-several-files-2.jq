def gsubst($from; $to):
  ($from | length) as $len
  | def g:
      index($from) as $ix
      | if $ix then .[:$ix]  + $to +  (.[($ix+$len):] | g) else . end;
     g;
