program GammaTest;
{$mode objfpc}{$H+}
uses SysUtils;

function Gamma( x : extended) : extended;
const COF : array [0..14] of extended =
(  0.999999999999997092, // may as well include this in the array
  57.1562356658629235,
 -59.5979603554754912,
  14.1360979747417471,
 -0.491913816097620199,
  0.339946499848118887e-4,
  0.465236289270485756e-4,
 -0.983744753048795646e-4,
  0.158088703224912494e-3,
 -0.210264441724104883e-3,
  0.217439618115212643e-3,
 -0.164318106536763890e-3,
  0.844182239838527433e-4,
 -0.261908384015814087e-4,
  0.368991826595316234e-5);
const
  K = 2.5066282746310005;
  PI_OVER_K = PI / K;
var
  j : integer;
  tmp, w, ser : extended;
  reflect : boolean;
begin
  reflect := (x < 0.5);
  if reflect then w := 1.0 - x else w := x;
  tmp := w + 5.2421875;
  tmp := (w + 0.5)*Ln(tmp) - tmp;
  ser := COF[0];
  for j := 1 to 14 do ser := ser + COF[j]/(w + j);
  try
    if reflect then
      result := PI_OVER_K * w * Exp(-tmp) / (Sin(PI*x) * ser)
    else
      result := K * Exp(tmp) * ser / w;
  except
    raise SysUtils.Exception.CreateFmt(
        'Gamma(%g) is undefined or out of floating-point range', [x]);
  end;
end;

// Main routine for testing the Gamma function
var
    x, k : extended;
begin
  WriteLn( 'Is it seamless at x = 1/2 ?');
  x := 0.49999999999999;
  WriteLn( SysUtils.Format( 'Gamma(%g) = %g', [x, Gamma(x)]));
  x := 0.50000000000001;
  WriteLn( SysUtils.Format( 'Gamma(%g) = %g', [x, Gamma(x)]));
  WriteLn( 'Test a few values:');
  WriteLn( SysUtils.Format( 'Gamma(1)   = %g', [Gamma(1)]));
  WriteLn( SysUtils.Format( 'Gamma(2)   = %g', [Gamma(2)]));
  WriteLn( SysUtils.Format( 'Gamma(3)   = %g', [Gamma(3)]));
  WriteLn( SysUtils.Format( 'Gamma(10)  = %g', [Gamma(10)]));
  WriteLn( SysUtils.Format( 'Gamma(101) = %g', [Gamma(101)]));
  WriteLn( '      100! = 9.33262154439442E157');
  WriteLn( SysUtils.Format( 'Gamma(1/2) = %g', [Gamma(0.5)]));
  WriteLn( SysUtils.Format( 'Sqrt(pi)   = %g', [Sqrt(PI)]));
  WriteLn( SysUtils.Format( 'Gamma(-7/2)       =  %g', [Gamma(-3.5)]));
(*
  Note here a bug or misfeature in Lazarus (doesn't occur in Delphi):
  Putting (16.0/105.0)*Sqrt(PI) does not give the required precision.
  We have to explicitly define the integers as extended floating-point.
*)
  k := extended(16.0)/extended(105.0);
  WriteLn( SysUtils.Format( ' (16/105)Sqrt(pi) =  %g', [k*Sqrt(PI)]));
  WriteLn( SysUtils.Format( 'Gamma(-9/2)       = %g', [Gamma(-4.5)]));
  k := extended(32.0)/extended(945.0);
  WriteLn( SysUtils.Format( '-(32/945)Sqrt(pi) = %g', [-k*Sqrt(PI)]));
end.
