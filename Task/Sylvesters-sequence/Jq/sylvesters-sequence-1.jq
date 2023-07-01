# Generate the sylvester integers:
def sylvester:
  foreach range(0; infinite) as $i ({prev: 1, product: 1};
    .product *= .prev
    | .prev = .product + 1;
    .prev);
