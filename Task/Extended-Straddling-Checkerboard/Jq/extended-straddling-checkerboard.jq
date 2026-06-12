### Generic utility
# Emit a stream of the constituent codepoints:
def chars: explode[] | [.] | implode;

### The checkerboard
def efigs: "0123456789";

def drow1: "012345";

def checkerboard:
  def row1: "AEINOT";
  def row2: "BCDFGHJKLM";
  def row3: "PQRSUVWXYZ";
  def row4: " .";
  { ewords: {
     "SPC":  "90",  "DOT": "91",
     "ACK":  "92",  "REQ": "93", "MSG": "94", "RV": "95",
     "GRID": "96", "SEND": "97", "FSL": "98", "SUPP": "99"
    },
    emap: {},
    dmap: {},
    dwords:{}
  }
  | reduce range(0; row1|length) as $i (.; .emap[row1[$i:$i+1]] = ($i|tostring) )
  | reduce range(0; row2|length) as $i (.; .emap[row2[$i:$i+1]] = ((70 + $i)|tostring))
  | reduce range(0; row3|length) as $i (.; .emap[row3[$i:$i+1]] = ((80 + $i)|tostring))
  | reduce range(0; row4|length) as $i (.; .emap[row4[$i:$i+1]] = ((90 + $i)|tostring))

  | reduce (.emap|keys[])   as $k (.; .dmap[.emap[$k]] = $k)
  | reduce (.ewords|keys[]) as $k (.; .dwords[.ewords[$k]] = $k) ;

def encode:
  (ascii_upcase|split(" ")) as $words
  | ($words|length) as $wc
  | checkerboard
  | .res = ""
  | reduce range(0; $wc) as $i (.;
      $words[$i] as $word
      | .add = ""
      |  if .ewords[$word]
         then .add = .ewords[$word]
         elif .ewords[$word[0:-1]] and ($word|endswith("."))
         then .add = .ewords[$word[0:-1]] + .ewords["DOT"]
         elif $word|startswith("CODE")
         then .add = "6" + $word[4:]
         else .figs = false
         | reduce ($word|chars) as $c (.;
             if (efigs|contains($c))
             then if .figs
                  then .add += 2 * $c
                  else .figs = true
                  | .add += .ewords["FSL"] + 2 * $c
                  end
             else .emap[$c] as $ec
             | if ($ec|not)
               then  "Message contains unrecognized character '\($c)'" | error
               else if .figs
                    then .add += .ewords["FSL"] + $ec
                    | .figs = false
                    else .add += $ec
                    end
                end
             end )
         | if .figs and ($i < $wc - 1)
           then .add += .ewords["FSL"]
           else .
           end
         end
         | .res += .add
         | if ($i < $wc - 1) then .res += .ewords["SPC"] else . end
  )
  | .res ;

def decode:
  {s: .} + checkerboard
  | .ewords["FSL"] as $fsl
  | .res = ""
  | .figs = false
  | until (.s == "";
      .s[0:1] as $c
      | .ix = -1
      | if .figs
        then if (.s | startswith($fsl) | not)
             then .res += $c
             else .figs = false
             end
             | .s |= .[2:]
        else .ix = (drow1|index($c))
        | if .ix and .ix >= 0
          then .res += .dmap[drow1[.ix:.ix+1]]
          | .s |= .[1:]
          elif $c == "6"
          then .res += "CODE" + .s[1:4]
          | .s |= .[4:]
          elif $c == "7" or $c == "8"
          then .s[1:2] as $d
          | .res += .dmap[$c + $d]
          | .s |= .[2:]
          elif $c == "9"
          then .s[1:2] as $d
          | if $d == "0"
            then .res += " "
            elif $d == "1"
            then .res +=  "."
            elif $d == "8"
            then .figs |= not
            else .res += .dwords[$c + $d]
            end
            | .s |= .[2:]
          end
         end )
  | .res ;

### Demonstration
def demo:
  "Message:\n\(.)",
   (encode
    | "\nEncoded:\n\(.)",
      "\nDecoded:\n\(decode)" );

"Admin ACK your MSG. CODE291 SEND further 2000 SUPP to HQ by 1 March"
| demo
