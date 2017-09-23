# Convert the input integer to an array of bits with lsb first
def integer_to_lsb:
  [recurse(if . > 0 then ./2|floor else empty end) | . % 2] ;

# input array of bits (with lsb first) is converted to an integer
def lsb_to_integer:
  reduce .[] as $bit
    # state: [power, ans]
    ([1,0]; (.[0] * 2) as $b | [$b, .[1] + (.[0] * $bit)])
  | .[1];

def xor(x;y):
   def lxor(a;b):  # a and/or b may be null
     if a == 1 then if b==1 then 0 else 1 end
     elif b==1 then if a==1 then 0 else 1 end
     else 0
     end;
   (x|integer_to_lsb) as $s
   | (y|integer_to_lsb) as $t
   | ([$s|length, $t|length] | max) as $length
   | reduce range(0;$length) as $i
      ([]; . + [ lxor($s[$i]; $t[$i]) ] )
   | lsb_to_integer;
