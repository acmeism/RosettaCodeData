def take(s; cond):
  label $done
  | foreach s as $n (null; $n; if $n | cond | not then break $done else . end);
