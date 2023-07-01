# "until" is available in more recent versions of jq
# than jq 1.4
def until(cond; next):
  def _until:
    if cond then . else (next|_until) end;
  _until;

# unordered
def proper_divisors:
  . as $n
  | if $n > 1 then 1,
      ( range(2; 1 + (sqrt|floor)) as $i
        | if ($n % $i) == 0 then $i,
            (($n / $i) | if . == $i then empty else . end)
          else empty
          end)
    else empty
    end;

# sum of proper divisors, or 0
def pdsum:
  [proper_divisors] | add // 0;

# input is n
# maxlen defaults to 16;
# maxterm defaults to 2^47
def aliquot(maxlen; maxterm):
  (maxlen // 15) as $maxlen
  | (maxterm // 40737488355328) as $maxterm
  | if . == 0 then "terminating at 0"
    else
    # [s, slen, new] = [[n], 1, n]
    [ [.], 1, .]
    | until( type == "string" or .[1] > $maxlen or .[2] > $maxterm;
             .[0] as $s | .[1] as $slen
             | ($s | .[length-1] | pdsum) as $new
             | if ($s|index($new)) then
                 if $s[0] == $new then
                     if $slen == 1 then "perfect \($s)"
                     elif $slen == 2 then "amicable: \($s)"
                     else "sociable of length \($slen): \($s)"
		     end
                 elif ($s | .[length-1]) == $new then "aspiring: \($s)"
                 else "cyclic back to \($new): \($s)"
		 end
               elif $new == 0 then "terminating: \($s + [0])"
               else [ ($s + [$new]), ($slen + 1), $new ]
               end )
    | if type == "string" then . else "non-terminating: \(.[0])" end
    end;

def task:
  def pp: "\(.): \(aliquot(null;null))";
     (range(1; 11) | pp),
     "",
     ((11, 12, 28, 496, 220, 1184, 12496, 1264460,
      790, 909, 562, 1064, 1488, 15355717786080) | pp);

task
