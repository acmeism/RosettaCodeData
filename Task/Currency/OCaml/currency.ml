let () =
  let open Decimal in (* bring all functions and operators into scope locally *)
  let s = of_string in
  let i = of_int in

  let hamburgers = s "4e15" * s "5.50" in
  let milkshakes = i 2 * s "2.86" in
  let tax_rate = s "7.65e-2" in
  let subtotal = hamburgers + milkshakes in
  let tax = subtotal * tax_rate in
  let total = subtotal + tax in

  Printf.printf
    "Subtotal: %20s
     Tax: %20s
   Total: %20s\n"
    (to_string (round ~n:2 subtotal))
    (to_string (round ~n:2 tax))
    (to_string (round ~n:2 total))
