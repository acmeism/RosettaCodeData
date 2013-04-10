module divzero ;
import std.stdio ;
import std.format ;

// check if a is unordered (NaN)
bool isNaN(T)(T a) { return a !<>= T.min ; }
// check for +ve & -ve infinity
bool isInf(T)(T a) { return a == T.infinity || -a == T.infinity ; }
// check if neither NaN nor Inf
bool isNormal(T)(T a) { return !(a !<> T.infinity || -a !<> T.infinity) ; }

string divCheck(T)(T numer, T denom) {
  T result ;
  string msg = "" ;
  static if (is(T : long)) { // Integral Type
    try {
      result = numer / denom ;
    } catch(Exception e) {
      msg = "! " ~ e.msg ~"(by Exception)" ;
      result = T.max ;
    }
  } else {                   // Float Type
    result = numer / denom ;
    if(isNormal(numer) && isInf(result))
      msg = "! Division by Zero" ;
    else if (!isNormal(result)) {
      if (isNaN(numer))
        msg = "! NaN numerator" ;
      else if(isNaN(denom))
        msg = "! NaN denominator" ;
      else if(isInf(numer))
        msg = "! Inf numerator" ;
      else
        msg = "! NaN(Zero Division by Zero)" ;
    }
  }
  return std.format.format("%5s %s", std.format.format("%1.1g", cast(real)result), msg) ;
}

void main() {
  writefln("Div with Check") ;
  writefln("int     1/ 0  : %s", divCheck(1, 0)) ;
  writefln("ubyte   1/ 0  : %s", divCheck(cast(ubyte)1, cast(ubyte)0)) ;
  writefln("real    1/ 0  : %s", divCheck(1.0L, 0.0L)) ;
  writefln("real   -1/ 0  : %s", divCheck(-1.0L, 0.0L)) ;
  writefln("real    0/ 0  : %s", divCheck(0.0L, 0.0L)) ;
  writefln() ;
  writefln("real   -4/-2  : %s", divCheck(-4.0L,-2.0L)) ;
  real inf = -1.0L / 0.0L ; // make an infinity
  writefln("real    2/-inf: %s", divCheck(2.0L, inf)) ;
  writefln() ;
  writefln("real -inf/-2  : %s", divCheck(inf, -2.0L)) ;
  writefln("real +inf/-2  : %s", divCheck(real.infinity, -2.0L)) ;
  writefln("real  nan/-2  : %s", divCheck(real.nan, -2.0L)) ;
  writefln("real   -2/ nan: %s", divCheck(-2.0L, real.nan)) ;
  writefln("real  nan/ 0  : %s", divCheck(real.nan, 0.0L)) ;
  writefln("real  inf/ inf: %s", divCheck(real.infinity, real.infinity)) ;
  writefln("real  nan/ nan: %s", divCheck(real.nan, real.nan)) ;
}
