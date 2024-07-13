include "bitwise" {search: "."};  # see above

def Const: 2685821657736338717;   # i.e. 0x2545F4914F6CDD1D
def Mask64: 18446744073709551615; # i.e. (1 | leftshift(64)) - 1
def Mask32: 4294967295;           # i.e. (1 | leftshift(32)) - 1

# Emit a suitable {state} object
def seed($num):
  {state: bitwise_and($num; Mask64)};

# Input: {state}
# Output: {state, nextInt}
def nextInt:
      .state |= bitwise_and(bitwise_xor(.;  rightshift(12)); Mask64)
    | .state |= bitwise_and(bitwise_xor(.;  leftshift( 25)); Mask64)
    | .state |= bitwise_and(bitwise_xor(.;  rightshift(27)); Mask64)
    | .nextInt = bitwise_and( bitwise_and(.state * Const; Mask64) | rightshift(32); Mask32) ;

# Input: {state}
# Output: {state, nextInt, nextFloat}
def nextFloat:
   nextInt
   | .nextFloat = (.nextInt / (pow(2;32)));

def task1:
  foreach range(0; 5) as $i (seed(1234567);
    nextInt;
    .nextInt);

def task2($max):
  reduce range(0; $max) as $i (seed(987654321);
    nextFloat
    | ((.nextFloat * 5)|floor) as $n
    | .counts[$n] += 1)
  | "\nThe counts for \($max) repetitions are:",
    (range(0; 5) as $i | "\($i) : \(.counts[$i])") ;

task1, "", task2(100000)
