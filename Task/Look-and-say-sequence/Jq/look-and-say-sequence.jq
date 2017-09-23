def look_and_say:
  def head(c; n): if .[n:n+1] == c then head(c; n+1) else n end;
  tostring
  | if length == 0 then ""
    else head(.[0:1]; 1) as $len
      | .[0:$len] as $head
      | ($len | tostring) + $head[0:1] + (.[$len:] | look_and_say)
    end ;

# look and say n times
def look_and_say(n):
  if n == 0 then empty
  else look_and_say as $lns
       | $lns, ($lns|look_and_say(n-1))
  end ;
