generic
   type Argument is private;
package Functions is
   type Primitive_Operation is not null
      access function (Value : Argument) return Argument;
   type Func (<>) is private;
   function "*" (Left : Func; Right : Argument) return Argument;
   function "*" (Left : Func; Right : Primitive_Operation) return Func;
   function "*" (Left, Right : Primitive_Operation) return Func;
   function "*" (Left, Right : Func) return Func;
private
   type Func is array (Positive range <>) of Primitive_Operation;
end Functions;
