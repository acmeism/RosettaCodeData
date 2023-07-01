/Matrix Exponentiation
/mpow.k
pow: {:[0=y; :({a=/:a:!x}(#x))];a: x; do[y-1; a: x _mul a]; :a}
