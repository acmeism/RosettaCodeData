include "bitwise" {search: "."};  # see above

# Arithmetically add 1 to the non-negative integer represented by the
# bit stream `stream`, in which the least significant bit is first.
def plusplus(stream):
  foreach (stream, null) as $bit ({carry: 1};
    if $bit == null
    then if .carry == 1 then .emit = 1 else empty end
    elif .carry == 0 then .emit = $bit
    ## .carry is now 1:
    elif $bit == 0 then {carry: 0, emit: 1 }
    else .emit = 0
    end )
  | .emit;

# input: a non-negative integer
# output: the bit array (with most-significant bit first and with length $width)
# corresponding to the twos-complement of the input integer, it being understood
# that all but the ($width-1) least significant bits of the binary representation of . are dropped.
def twosComplement($width):
  def rpad($width): ($width - length) as $l | . + [range(0; $l) | 0];
  if . < 0 then "input of twosComplement should be non-negative" | error
  else [flipbits( [limit($width; bitwise)] | rpad($width) | .[] )]
  | [limit($width; plusplus(.[]))]
  | reverse
  end;

def illustrate($width):
  "decimal: \(.)",
  "binary: \([bitwise] | reverse | join(""))",
  "twos-complement(\($width)): \(twosComplement($width) | join(""))",
  "";

( 3
 | illustrate(8)),
(737894120670 # 0xABCDEABCDE9
 | illustrate(64))
