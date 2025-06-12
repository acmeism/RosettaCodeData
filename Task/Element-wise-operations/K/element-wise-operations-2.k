pow: {:[`f=@|/,//y; `exp y*`ln x       / floating point exponent
  |/,//s:y<0;o[(s+x*~s)%(~s)+x*s;y|-y] / negative exponent: reciprocate base
  */(~b)+((-1+#b){x*x}\x)*b:|2\y]}     / binary exponentiation
pow[matrix;matrix]         / integer power of integer base
pow[0.0+matrix;matrix]     / integer power of floating point base
pow[0.0+matrix;0.0+matrix] / floating point power of floating point base
