# For handling hex character codes &#x
def hex2i:
  def toi: if . >= 87 then .-87 else . - 48 end;
  reduce ( ascii_downcase | explode | map(toi) | reverse[]) as $i ([1, 0]; # [power, sum]
    .[1] += $i * .[0]
    | .[0] *= 16 )
  | .[1];

def hexcode2json:
  gsub("&#x(?<x>....);" ; .x | [hex2i] | implode) ;

def jsonify:
  walk( if type == "array"
        then map(select(type == "string" and test("^\n *$") | not))
	elif type == "string" then hexcode2json
	else . end);

# First convert to JSON ...
XML | jsonify
# ... and then extract Student Names
| .[]
| (.Students[].Student[]["@attributes"] // empty).Name
