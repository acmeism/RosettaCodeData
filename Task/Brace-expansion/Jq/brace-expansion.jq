# Input: a string
# Emit an array of the expansions
def expand:

  # Emit [ array, string ]
  def getItem($depth):

  def getGroup($depth):
    { out: [], comma: false, s: . }
    | until (.s == "" or .return;
        (.s | getItem($depth)) as $t
        | $t[0] as $g
        | .s = $t[1]
        | if .s == "" then .return = [[], ""]
          else .out += $g
          | if .s[0:1] == "}"
            then if .comma then .return = [.out, .s[1:]]
                 else .return = [ (.out | map( "{" + . + "}" )), .s[1:]]
                 end
            else if .s[0:1] == ","
                 then .comma = true
                 | .s |= .[1:]
                 else .
	         end
            end
     	  end)
    | if .return then .return else [[], ""] end ;

    { out: [""], s: .}
    | until( (.s == "") or .return;
        .c = .s[0:1]
        | if ($depth > 0) and (.c == "," or .c == "}")
	  then .return = [.out, .s]
      else .cont = false
      | if .c == "{"
	    then (.s[1:] | getGroup($depth+1)) as $x
        | if $x[0] | length > 0
          # conform to the "lexicographic" ordering requirement
          then .out |= [ .[] as $o | $o + $x[0][] ]
          | .s = $x[1]
          | .cont = true
	      else .
	      end
        else .
        end
	  end
      | if (.cont | not)
        then if (.c == "\\") and ((.s|length) > 1)
	         then .c += .s[1:2]
             | .s |= .[1:]
             else .
		     end
        | .out = [.out[] + .c]
        | .s |= .[1:]
        else .
	    end )
      | if .return then .return else [.out, .s] end ;

    getItem(0)[0];

def inputs: [
     "~/{Downloads,Pictures}/*.{jpg,gif,png}",
    "It{{em,alic}iz,erat}e{d,}, please.",
    "{,{,gotta have{ ,\\, again\\, }}more }cowbell!",
    "{}} some }{,{\\\\{ edge, edge} \\,}{ cases, {here} \\\\\\\\\\}"
];

inputs[]
| "\n",
  .,
  "    " + expand[]
