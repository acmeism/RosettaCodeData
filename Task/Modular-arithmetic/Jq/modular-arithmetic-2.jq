# "ModularArithmetic" objects are represented by JSON objects of the form: {value, mod}.
# The function modint::assert/0 checks the input is of this form with integer values.

def is_modint: type=="object" and has("value") and has("mod");

def modint::assert:
   assert(type=="object"; "object expected")
   | assert(has("value"); "object should have a value")
   | assert(has("mod"); "object should have a mod")
   | assert(.value | is_integer; "value should be an integer")
   | assert(.mod   | is_integer; "mod should be an integer");

def modint::make($value; $mod):
  assert($value|is_integer; "value should be an integer")
  | assert($mod|is_integer; "mod should be an integer")
  | { value: ($value % $mod), mod: $mod};

def modint::add($A; $B):
  if ($B|type) == "object"
  then assert($A.mod == $B.mod ; "modint::add")
  | modint::make( $A.value + $B.value; $A.mod )
  else modint::make( $A.value + $B; $A.mod )
  end;

def modint::mul($A; $B):
  if ($B|type) == "object"
  then assert($A.mod == $B.mod ; "mul")
  | modint::make( $A.value * $B.value; $A.mod )
  else modint::make( $A.value * $B; $A.mod )
  end;

def modint::pow($A; $pow):
  assert($pow | is_integer; "pow")
  | reduce range(0; $pow) as $i ( modint::make(1; $A.mod);
      modint::mul( .; $A) );

# pretty print
def modint::pp: "«\(.value) % \(.mod)»";
