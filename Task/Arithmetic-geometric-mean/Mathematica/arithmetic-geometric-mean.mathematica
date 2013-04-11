PrecisionDigits = 85;
AGMean[a_, b_] := FixedPoint[{ (Plus@@#)/2, Sqrt[Times@@#] }&, N[{a,b}, PrecisionDigits]][[1]]
