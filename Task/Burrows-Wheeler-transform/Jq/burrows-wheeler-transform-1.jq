# substitute ^ for STX and | for ETX
def makePrintable:
  if . == null then null
  else sub("\u0002"; "^") | sub("\u0003"; "|")
  end;

def bwt:
  {stx: "\u0002", etx: "\u0003"} as $x
  | if index($x.stx) >= 0 or index($x.etx) >= 0 then null
    else $x.stx + . + $x.etx
    | . as $s
    | (reduce range(0; length) as $i ([];
         .[$i] = $s[$i:] + $s[:$i]) | sort) as $table
    | reduce range(0; length) as $i ("";
         . + $table[$i][-1:])
    end;

def ibwt:
  . as $r
  | length as $len
  | reduce range(0;$len) as $i ([];
        reduce range(0; $len) as $j (.;
	.[$j] = $r[$j:$j+1] + .[$j]) | sort)
  | first( .[] | select(endswith("\u0003")))
  | .[1:-1] ;
