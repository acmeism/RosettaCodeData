# peeloff(delims) either peels off a delimiter or
# a single character from the input string.
# The input should be a nonempty string, and delims should be
# a non-empty array of delimiters;
# return [peeledoff, remainder]
# where "peeledoff" is either [delim] or the peeled off character:
def peeloff(delims):
  delims[0] as $delim
  | if startswith($delim) then [ [$delim], .[ ($delim|length):]]
    elif (delims|length)>1 then peeloff(delims[1:])
    else [ .[0:1], .[1:]]
    end ;

# multisplit_parse(delims) produces an intermediate parse.
# Input must be of the parse form: [ string, [ delim ], ... ]
# Output is of the same form.
def multisplit_parse(delims):
  if (delims|length) == 0 or length == 0 then .
  else
    .[length-1] as $last
    |  .[0:length-1] as $butlast
    | if ($last|type) == "array" then . # all done
      elif $last == "" then .
      else
        ($last | peeloff(delims)) as $p # [ peeledoff, next ]
        | $p[0] as $peeledoff
        | $p[1] as $next
        | if ($next|length) > 0
          then $butlast + [$peeledoff] + ([$next]|multisplit_parse(delims))
          else $butlast + $p
          end
      end
  end ;

def multisplit(delims):
  [.] | multisplit_parse(delims)
  # insert "" between delimiters, compress strings, remove trailing "" if any
  | reduce .[] as $x ([];
      if length == 0 then [ $x ]
      elif ($x|type) == "array"
      then if (.[length-1]|type) == "array" then . + ["",  $x]
           else  . + [$x]
           end
      elif .[length-1]|type == "string"
      then .[0:length-1] + [ .[length-1] + $x ]
      else  . + [$x]
      end ) ;
