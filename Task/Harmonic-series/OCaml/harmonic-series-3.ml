module Q = struct
  include Stdlib.Float
  let (~$) = of_int
  let (+) = add
  let inv = div 1.
  let pp_print = Stdlib.Format.pp_print_float
end
