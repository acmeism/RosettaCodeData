def expand_range:
  def number: "-?[0-9]+";
  def expand: [range(.[0]; .[1] + 1)];

  split(",")
  | reduce .[] as $r
      ( []; . +
            ($r | if test("^\(number)$") then [tonumber]
                  else sub( "(?<x>\(number))-(?<y>\(number))"; "\(.x):\(.y)")
                  | split(":") | map(tonumber) | expand
	          end));
