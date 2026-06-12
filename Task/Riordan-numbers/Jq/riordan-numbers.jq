def riordan:
  {ai: 1, a1: 0}
  | ., foreach range(1; infinite) as $i (.;
         {ai: ( ($i-1) * (2*.ai + 3*.a1) / ($i+1)),
          a1: .ai } )
  | .ai ;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def snip($n):
  tostring|lpad(6)
  + ($n | tostring | "th: \(.[:10]) .. \(.[-10:]) (\(length) digits)" );

"First 32 Riordan numbers:",
foreach limit(100000; riordan) as $riordan (0; .+1;
    if . <= 32 then $riordan
    elif . == 1000  or . == 10000 or . == 100000 then snip($riordan)
    else empty end)
