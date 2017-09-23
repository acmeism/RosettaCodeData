# Set n to -1 to continue indefinitely:
def happy(n):
  def subtask:  # state: [i, found]
    if .[1] == n then empty
    else .[0] as $n
    | if ($n | is_happy_number) then $n, ([ $n+1, .[1]+1 ] | subtask)
      else  (.[0] += 1) | subtask
      end
    end;
    [0,0] | subtask;

happy($n|tonumber)
