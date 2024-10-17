let calc n =
   Printf.printf
      "Gauss-Legendre %2d-point quadrature for exp over [-3..3] = %.16f\n"
      n (quadrature n exp (-3.0) 3.0);;

calc 5;;
calc 10;;
calc 15;;
calc 20;;
