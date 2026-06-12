def count(stream): reduce stream as $x (0; .+1);

def sameCount(stream):
  if . == false then false
  else . as $n
  | first(
      foreach (stream,null) as $x ({i:0};
        if $x == null then .emit = ($n == .i)
        else .i += 1
        | if .i > $n then .emit = false end
        end )
      | select(.emit != null).emit  )
  end;

# Report true or false as the counts of "a", "b" and "c" are equal.
def abc:
  tostring
  | length as $n
  | [explode[] | [.] | implode] as $s
  | count($s[] | select(. == "a"))
  | if (3 * .) > $n then false
    else sameCount($s[] | select(. == "b")) and sameCount($s[] | select(. == "c"))
    end;

inputs
| if abc then "\(.) is an \"abc\" word"
  else "\(.) is NOT an \"abc\" word"
  end
