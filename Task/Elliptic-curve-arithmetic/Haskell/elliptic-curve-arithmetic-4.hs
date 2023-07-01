ellipticX b y = Elliptic (qroot (y^2 - b)) y
  where qroot x = signum x * abs x ** (1/3)
