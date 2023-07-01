# A generator
def humbles($digits):
  def update:
    .[0] as $h
    | ([$h * 2, $h * 3, $h * 5, $h * 7] | map(select(tostring|length <= $digits))) as $next
    | if $next == [] then .[1:]
      else (.[1:] + $next) | sort
      end;
  def trim: if length <= 1 then . elif .[0]==.[1] then .[1:]|trim else . end;

  { queue: [1]}
  | recurse( select( .queue != [] )
             | .h = .queue[0]
             | queue |= (update|trim) )
  | .h ;

def distribution(stream):
   reduce stream as $i ([]; .[$i|tostring|length-1]+=1);

def task($digits):
  "Distribution of the number of decimal digits up to \($digits) digits:",
  (distribution(humbles($digits)) | range(0;length) as $i | "  \($i+1):  \(.[$i])") ;

task(16)
