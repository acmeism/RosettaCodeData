def select_while(s; cond):
  label $done
  | s
  | if (cond|not) then break $done else . end;

def cubrt: log / 3 | exp;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def pp($n; $width): _nwise($n) | map(tostring|lpad($width)) | join(" ");
