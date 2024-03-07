# Generic preliminaries

# To take advantage of gojq's arbitrary-precision integer arithmetic:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

# To take advantage of gojq's arbitrary-precision integer arithmetic:
# if the input and $j are integers, then the result will be an integer.
def div($j):
  (. - (. % j)) / $j;

# integer to stream of 0s and 1s, least significant bit first
def bitwise:
  recurse( if . >= 2 then div(2) else empty end) | . % 2;

# inverse of `bitwise`
def stream_to_integer(stream):
  reduce stream as $c ( {power:1 , ans: 0};
      .ans += ($c * .power) | .power *= 2 )
    | .ans;

# Input determines the max number of bits to be retained
# $x and $y are two integers
def xorBits($x;$y):
   def lxor(a;b):
     if (a==1 or b==1) and ((a==1 and b==1)|not) then 1
     elif a == null then b
     elif b == null then a
     else 0
     end;
   if $x == 0 then $y
   elif $y == 0 then $x
   else
     [if . then limit(.; $x|bitwise) else $x|bitwise end] as $s
   | [if . then limit(.; $y|bitwise) else $y|bitwise end] as $t
   | stream_to_integer(
       range(0; [($s|length), ($t|length)] | max) as $i
       | lxor($s[$i]; $t[$i]) )
   end ;

# $x and $y are two integers
def xor($x;$y):
   null | xorBits($x;$y);

def count(stream): reduce stream as $i (0; .+1);

# Input: an array
def insert($i; $x): .[:$i] + [$x] + .[$i:];

# Input: a non-negative integer
def tobase($b):
  def digit: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"[.:.+1];
  def mod: . % $b;
  def div: ((. - mod) / $b);
  def digits: recurse( select(. > 0) | div) | mod ;
  # For jq it would be wise to protect against `infinite` as input, but using `isinfinite` confuses gojq
  select( (tostring|test("^[0-9]+$")) and 2 <= $b and $b <= 36)
  | if . == 0 then "0"
    else [digits | digit] | reverse[1:] | add
    end;

# Input: a string in base $b
# Output: its decimal value
def frombase($b):
  def decimalValue:
    if   48 <= . and . <= 57 then . - 48
    elif 65 <= . and . <= 90 then . - 55  # (10+.-65)
    elif 97 <= . and . <= 122 then . - 87 # (10+.-97)
    else "decimalValue <- \(.)" | error
    end;
  reduce (explode|reverse[]|decimalValue) as $x ({p:1};
    .value += (.p * $x)
    | .p *= $b)
  | .value ;

### Parse an IP address

# An IPAddress is represented by an object {"address", "addressSpace", "port"}
# where addressSpace is one of "IPv4", "IPv6", "Invalid"
# and a port of -1 denotes 'not specified'.

def INVALID: {address: 0, addressSpace: "Invalid", port: 0};

def ipAddressParse:

  # Helper for octet1
  # Assumes .len == (.hextets|length)
  def fixhextets:
      .insertions = (8 - .len)
      | .i = 0
      | until(.i == 8;
          if .hextets[.i] == ""
          then .hextets[.i] = "0"
          | until( .insertions <= 0;
              .insertions += -1
              | .i as $i
              | .hextets |= insert($i; "0") )
              | .i = 8
          else .i += 1
          end ) ;

  # Handle the case when octet length is 4
  def octet4:
      (.octets[0] | split(":")) as $split
      | if $split|length == 2
        then ($split[1]|tonumber? // null) as $temp
        | if $temp | (. == null or . < 0 or . > 65535)
          then .return = INVALID
          else .port = $temp
          | .octets[0] = $split[0]
          end
        else .
        end
      | if .return then .
        else reduce range(0;4) as $i (.;
          if .return then .
          else (.octets[$i] | tonumber? // null) as $num
          | if $num | (. == null or . < 0 or . > 255) then .return = INVALID
            else .address = xor(.address; $num * (2 | power($i * 8)))
            end
          end)
        end
      | if .return then .
        elif .trans
        then .address += 281470681743360 # "ffff00000000"
        else .
        end ;

  # Handle the case when octet length is 1
  def octet1:
      .addressSpace = "IPv6"
      | if .ipa[0:1] == "["
        then .ipa |= .[1:]
        | (.ipa | split("]:")) as $split
        | if $split|length != 2 then .return = INVALID
          else ($split[1] | tonumber? // null) as $temp
          | if $temp | (. == null or . < 0 or . > 65535) then .return = INVALID
            else .port = $temp
            | .ipa |= .[0: (-2 - ($split[1]|length))]
            end
          end
        else .
        end
      | if .return then .
        else .hextets = (.ipa | split(":")|reverse)
        | .len = (.hextets|length)
        | if .ipa|startswith("::")
          then .hextets[-1] = "0"
          elif .ipa|endswith("::")
          then .hextets[0] = "0"
          else .
          end
        | if .ipa == "::" then .hextets[1] = "0" else . end
        | if .len > 8 or (.len == 8 and any(.hextets[]; . == "")) or count(.hextets[] | select(. == "")) > 1
          then .return = INVALID
          else .
          end
        end
      | if .return then .
        elif .len < 8
        then fixhextets
        else .
        end
      | if .return then .
        else reduce range(0; 8) as $j (.;
            if .return then .
            else (.hextets[$j] | frombase(16)) as $num
            | if $num > 65535 then .return = INVALID
              else .address = xor(.address; $num * (2 | power($j * 16)))
              end
            end)
        end ;

  { addressSpace: "IPv4",
    ipa: ascii_downcase,
    port: -1,
    trans: false }
  | if (.ipa|startswith("::ffff:")) and (.ipa|test("[.]"))
    then .addressSpace = "IPv6"
    | .trans = true
    | .ipa |= .[7:]
    elif (.ipa|startswith("[::ffff:")) and (.ipa|test("[.]"))
    then .addressSpace = "IPv6"
    | .trans = true
    | .ipa |= (.[8:] | gsub("]";""))
    else .
    end
  | .octets = (.ipa | split(".") | reverse)
  | .address = 0
  | if .octets|length == 4
    then octet4
    elif .octets|length == 1
    then octet1
    else .return = INVALID
    end
  | if .return then .return
    else {address, addressSpace, port}
    end ;

# Examples
def ipas:
    "127.0.0.1",
    "127.0.0.1:80",
    "::1",
    "[::1]:80",
    "2605:2700:0:3::4713:93e3",
    "[2605:2700:0:3::4713:93e3]:80",
    "::ffff:192.168.173.22",
    "[::ffff:192.168.173.22]:80",
    "1::",
    "::",
    "256.0.0.0",
    "::ffff:127.0.0.0.1"
;

ipas
| "IP address    : \(.)",
( ipAddressParse
| "Address       : \(.address|tobase(16))",
  "Address Space : \(.addressSpace)",
  "Port          : \(if .port == -1 then "not specified" else .port end)",
  ""
)
