>>> 12/3  # Implicit cast from int to float, by / operator.
4.0
>>> (2+4j)/2  # But no implicit cast for complex parts.
(1+2j)
>>> (11.5+12j)/0.5  # Quasi-case, complex parts implicit cast from float to int.
(23+24j)
