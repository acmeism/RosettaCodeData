# `prompts` should be an array defining the prompts, variable names, and their types,
# as exemplified below.
# After all values have been gathered, `get` emits an object defining the bindings.
def get($prompts):
  label $out
  | foreach range(0;infinite) as $_ ({i:null, imax: ($prompts|length)};
      if .i == null then .i = 0
      elif .i == .imax then break $out
      else .help = null
      | first(inputs) as $n
      | $prompts[.i].type as $type
      | if $type == null or $type == "string"
        then .result[$prompts[.i].key] = $n
        | .i += 1
        elif $type == "number"
        then (try ($n|tonumber) catch null) as $n
        | if $n then .result[$prompts[.i].key] = $n
          | .i += 1
          else .help = .i
          end
        elif $type == "integer"
	then if ($n|test("^[0-9]+$"))
             then .result[$prompts[.i].key] = ($n|tonumber)
             | .i += 1
	     else .help = .i
	     end
        elif $type|type == "object"
	then if $type.regex and ($n | test($type.regex))
             then .result[$prompts[.i].key] = $n
             | .i += 1
	     else .help = .i
	     end
        else .
        end
      end;
   (select(.help) | $prompts[.help].help // empty),
   if .i < .imax then $prompts[.i].prompt
   else .result
   end )
   ;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;
def rpad($len): tostring | ($len - length) as $l | . + ("0" * $l)[:$l];

# Input: a string of digits with up to one "."
# Output: the corresponding string representation with exactly $n decimal digits
def align_decimal($n):
  tostring
  | if index(".")
    then capture("(?<i>[0-9]*[.])(?<j>[0-9]{0," + ($n|tostring) + "})")
    | .i + (.j|rpad($n))
    else . + "." + ("0" * $n)
    end ;

def pi: 4*(1|atan);
