# Start with the 'not' and 'and' building blocks.
# These allow us to construct 'nand', 'or', and 'xor',
# and so on.

def bit_not: if . == 1 then 0 else 1 end;

def bit_and(a; b): if a == 1 and b == 1 then 1 else 0 end;

def bit_nand(a; b): bit_and(a; b) | bit_not;

def bit_or(a; b): bit_nand(bit_nand(a;a); bit_nand(b;b));

def bit_xor(a; b):
  bit_nand(bit_nand(bit_nand(a;b); a);
           bit_nand(bit_nand(a;b); b));

def halfAdder(a; b):
  { "carry": bit_and(a; b), "sum": bit_xor(a; b) };

def fullAdder(a; b; c):
  halfAdder(a; b) as $h0
  | halfAdder($h0.sum; c) as $h1
  | {"carry": bit_or($h0.carry; $h1.carry), "sum": $h1.sum };

# a and b should be strings of 0s and 1s, of length no greater than 4
def fourBitAdder(a; b):

  # pad on the left with 0s, and convert the string
  # representation ("101") to an array of integers ([1,0,1]).
  def pad: (4-length) * "0" + . | explode | map(. - 48);

  (a|pad) as $inA | (b|pad) as $inB
  | [][3] = null                                # an array for storing the four results
  | halfAdder($inA[3]; $inB[3]) as $pass
  | .[3] = $pass.sum                            # store the lsb
  | fullAdder($inA[2]; $inB[2]; $pass.carry) as $pass
  | .[2] = $pass.sum
  | fullAdder($inA[1]; $inB[1]; $pass.carry) as $pass
  | .[1] = $pass.sum
  | fullAdder($inA[0]; $inB[0]; $pass.carry) as $pass
  | .[0] = $pass.sum
  | map(tostring) | join("") ;
