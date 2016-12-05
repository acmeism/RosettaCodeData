def ternary_nand(a; b):
  if a == false or b == false then true
  elif a == "maybe" or b == "maybe" then "maybe"
  else false
  end ;

def ternary_not(a):    ternary_nand(a; a);

def ternary_or(a; b):  ternary_nand( ternary_not(a); ternary_not(b) );

def ternary_nor(a; b): ternary_not( ternary_or(a;b) );

def ternary_and(a; b): ternary_not( ternary_nand(a; b) );

def ternary_imply(this; that):
  ternary_nand(this, ternary_not(that));

def ternary_equiv(this; that):
  ternary_or( ternary_and(this; that); ternary_nor(this; that) );

def display_and(a; b):
  a as $a | b as $b
  | "\($a) and \($b) is \( ternary_and($a; $b) )";
def display_equiv(a; b):
  a as $a | b as $b
  | "\($a) equiv \($b) is \( ternary_equiv($a; $b) )";
# etc etc

# Invoke the display functions:
display_and( (false, "maybe", true );  (false, "maybe", true) ),
display_equiv( (false, "maybe", true );  (false, "maybe", true) ),
"etc etc"
