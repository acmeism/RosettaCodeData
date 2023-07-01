a = [sin(_), cos(_), { |x| x ** 3 }];
b = [asin(_), acos(_), { |x| x ** (1/3) }];
c = a.collect { |x, i| x <> b[i] };
c.every { |x| x.(0.5) - 0.5 < 0.00001 }
