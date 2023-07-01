type

  # Kind of numbers. We limit this example to "int" and "float".
  NumberKind = enum kInt, kFloat

  # Customized number type (using variants).
  Number = object
    case kind: NumberKind
    of kInt:
      ival: int
    of kFloat:
      fval: float

# The converters allow transparent conversion from int or float to Number.
converter toNumber(n: int): Number = Number(kind: kInt, ival: n)
converter toNumber(n: float): Number = Number(kind: kFloat, fval: n)

#---------------------------------------------------------------------------------------------------

proc accumulator[T: int|float](x: T): auto =
  ## Factory procedure.

  # Allocate the accumulator storage.
  when T is int:
    var sum = Number(kind: kInt, ival: x)
  elif T is float:
    var sum = Number(kind: kFloat, fval: x)

  # Create the accumulator procedure.
  result = proc (n: Number): Number =
    # Create the accumulator procedure.
  result = proc (n: Number): Number =
             case sum.kind
             of kInt:
               case n.kind
               of kInt:
                 # Add an int to an int.
                 sum.ival += n.ival
               of kFloat:
                 # Add a float to an int => change the kind of accumulator to float.
                 sum = Number(kind: kFloat, fval: sum.ival.toFloat + n.fval)
             of kFloat:
               case n.kind
               of kInt:
                 # Add an int to a float.
                 sum.fval += n.ival.toFloat
               of kFloat:
                 # Add a float to a float.
                 sum.fval += n.fval
             result = sum

#---------------------------------------------------------------------------------------------------

proc `$`(n: Number): string =
  ## Display the accumulator contents as an int or a float depending of its kind.
  case n.kind
  of kInt: $n.ival
  of kFloat: $n.fval

#---------------------------------------------------------------------------------------------------

let acc = accumulator(1)
echo acc(5)             # 6
discard accumulator(3)  # Create another accumulator.
echo acc(2.3)           # 8.3
