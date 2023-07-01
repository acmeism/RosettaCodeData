# ibase($base) interprets its input as a number in base $base, and emits the
# corresponding decimal value. $base may be any positive integer.
#
# If the input is a JSON number, and the $base is 10, then the input is simply echoed.
# Otherwise, the input should be a JSON integer or an alphanumeric
# string optionally preceded by one or more occurrences of "-", and
# optionally surrounded by blanks.
# Examples: `"A"|base(2)` => 10
#
def ibase($base):
  def tod: if 48 <= . and . <=  57 then . - 48  # 0-9
  	 elif 65 <= . and . <=  90 then . - 55  # A-Z
         elif 97 <= . and . <= 122 then . - 87  # a-z
	 else "ibase cannot handle codepoint \(.)" | error
	 end;
  if type == "number" and $base==10 then .
  else
    tostring
    | sub("^  *";"") | sub("  *$";"") | sub("^0*";"")
    | if startswith("-") then -  (.[1:] | ibase($base))
      else
      reduce (tostring|explode|reverse[]) as $point ({value: null, p: 1};
        .value += ($point|tod) * .p
      | .p *= $base)
    | .value
    end
  end;

# After stripping off leading spaces and then leading "-" signs,
# infer the base from the input string as follows:
# prefix 0b for base 2, 0o for base 8, 0x for base 16,
# otherwise base 10
def ibase:
  if type=="number" then .
  else capture("^ *(?<signs>-*)(?<x>[^ ]*) *$") as $in
    | $in.x
    | if . == null then null
      else (if startswith("0b") then .[2:] | ibase(2)
            elif startswith("0o") then .[2:] | ibase(8)
            elif startswith("0x") then .[2:] | ibase(16)
            else ibase(10)
            end) as $y
      | if ($in.signs | length) % 2 == 0 then $y else - $y end
      end
  end;
