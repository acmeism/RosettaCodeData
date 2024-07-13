include "bitwise" {search: "."};  # see above

def Const: 6364136223846793005;
def Mask64: 18446744073709551615; # i.e. (1 | leftshift(64)) - 1
def Mask32: 4294967295;           # i.e. (1 | leftshift(32)) - 1

# An initialization function if you do not wish to use seed/2
def rcg32:
  {state:  9600629759793949339,   #  0x853c49e6748fea9b
   inc:   15726070495360670683    # 0xda3e39cb94b95bdb
  };

# Input: {state, inc}
# Output: {state, inc, nextInt}
def nextInt:
  .state as $old
  | .state = bitwise_and($old * Const + .inc; Mask64)
  | bitwise_and(( bitwise_xor($old | rightshift(18); $old) | rightshift(27)); Mask32) as $xorshifted
  | bitwise_and($old|rightshift(59) ; Mask32) as $rot
  | .nextInt = bitwise_and(
                 bitwise_or(
                   $xorshifted | rightshift($rot) ;
                   $xorshifted | leftshift( bitwise_and( 32 - $rot; 31) )) ;
                 Mask32) ;

def nextFloat:
  nextInt
  | .nextFloat = .nextInt / pow(2;32);

def seed($seedState; $seedSequence):
   {state: 0,
    inc:   bitwise_and( bitwise_xor($seedSequence|leftshift(1); 1); Mask64)
    }
   | nextInt
   | .state += $seedState
   | nextInt;

def task1($n):
  foreach range(0; $n) as $i (seed(42; 54); nextInt)
  | .nextInt;

def task2($n):
  reduce range(0; $n) as $i (seed(987654321; 1);
    nextFloat
    | .counts[((.nextFloat * 5)|floor)] += 1)
  | "\nThe counts for \($n) repetitions are:",
    (range(0; 5) as $i | "\($i) : \(.counts[$i])") ;

task1(5),
task2(100000)
