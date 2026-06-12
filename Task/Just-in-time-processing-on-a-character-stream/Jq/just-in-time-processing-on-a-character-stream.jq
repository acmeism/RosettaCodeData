# User input takes the form of quadtuples of integers: [formFeed, lineFeed, tab, space]
def getUserInput:
  def nwise($n):
    def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

  "0 18 0 0 0 68 0 1 0 100 0 32 0 114 0 45 0 38 0 26 0 16 0 21 0 17 0 59 0 11 " +
  "0 29 0 102 0 0 0 10 0 50 0 39 0 42 0 33 0 50 0 46 0 54 0 76 0 47 0 84 2 28"
  | split(" ") | map(tonumber) | nwise(4)
  | {formFeed: .[0], lineFeed: .[1], tab: .[2], space: .[3]} ;

def emit_until(cond; stream):
  label $out | stream | if cond then break $out else . end;

# Input should be the text as a (long) string
def decode($uiList):
  def stream: explode[] | [.] | implode;
  def decode2(ui):
    . as $text
    | label $out
    | foreach stream as $c (
          { f: 0, l: 0, t: 0, s: 0 };
          if .f == ui.formFeed and .l == ui.lineFeed and .t == ui.tab and .s == ui.space
          then .out = $c
          elif $c == "\f"
          then .f += 1
          | .l = 0
          | .t = 0
          | .s = 0
          elif $c == "\n"
          then .l += 1
          | .t = 0
          | .s = 0
          elif $c == "\t"
          then .t += 1
          | .s = 0
          else .s += 1
	  end;
	if .out then .out, break $out else empty end )
    // "" ;
  decode2($uiList) ;

# Input: the text
[emit_until(. == "!"; getUserInput as $ui | decode($ui)) ] | add
