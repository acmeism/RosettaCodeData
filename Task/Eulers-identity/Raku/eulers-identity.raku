sub infix:<⁢> is tighter(&infix:<**>) { $^a * $^b };

say 'e**i⁢π + 1 ≅ 0 : ', e**i⁢π + 1 ≅ 0;
say 'Error: ', e**i⁢π + 1;
