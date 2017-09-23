def round(n):
  (if . < 0 then -1 else 1 end) as $s
  | $s*10*.*n | if (floor%10)>4 then (.+5) else . end | ./10 | floor/n | .*$s;

range(2;6) | . as $base | "Base \(.): \( [ range(0;11) | vdc($base)|round(1000) ] )"
