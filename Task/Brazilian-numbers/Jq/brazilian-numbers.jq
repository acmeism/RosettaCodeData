# Output: a stream of digits, least significant digit first
def to_base($base):
  def butlast(s):
    label $out
    | foreach (s,null) as $x ({};
        if $x == null then break $out else .emit = .prev | .prev = $x end;
        select(.emit).emit);

  if . == 0 then 0
  else butlast(recurse( if . == 0 then empty else ./$base | floor end ) % $base)
  end ;


def sameDigits($n; $b):
  ($n % $b) as $f
  | all( ($n | to_base($b)); . == $f)  ;

def isBrazilian:
  . as $n
  | if . < 7 then false
    elif (.%2 == 0 and . >= 8) then true
    else any(range(2; $n-1); sameDigits($n; .) )
    end;

def brazilian_numbers($m; $n; $step):
  range($m; $n; $step)
  | select(isBrazilian);

def task($n):
  "First \($n) Brazilian numbers:",
   limit($n; brazilian_numbers(7; infinite; 1)),
  "First \($n) odd Brazilian numbers:",
   limit($n; brazilian_numbers(7; infinite; 2)),
  "First \($n) prime Brazilian numbers:",
   limit($n; brazilian_numbers(7; infinite; 2) | select(is_prime)) ;

task(20)
