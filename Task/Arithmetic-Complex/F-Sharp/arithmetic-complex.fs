> open Microsoft.FSharp.Math;;

> let a = complex 1.0 1.0;;
val a : complex = 1r+1i

> let b = complex 3.14159 1.25;;
val b : complex = 3.14159r+1.25i

> a + b;;
val it : Complex = 4.14159r+2.25i {Conjugate = 4.14159r-2.25i;
                                   ImaginaryPart = 2.25;
                                   Magnitude = 4.713307515;
                                   Phase = 0.497661247;
                                   RealPart = 4.14159;
                                   i = 2.25;
                                   r = 4.14159;}

> a * b;;
val it : Complex = 1.89159r+4.39159i {Conjugate = 1.89159r-4.39159i;
                                      ImaginaryPart = 4.39159;
                                      Magnitude = 4.781649868;
                                      Phase = 1.164082262;
                                      RealPart = 1.89159;
                                      i = 4.39159;
                                      r = 1.89159;}

> a / b;;
val it : Complex =
  0.384145932435901r+0.165463215905043i
    {Conjugate = 0.384145932435901r-0.165463215905043i;
     ImaginaryPart = 0.1654632159;
     Magnitude = 0.418265673;
     Phase = 0.4067140652;
     RealPart = 0.3841459324;
     i = 0.1654632159;
     r = 0.3841459324;}

> -a;;
val it : complex = -1r-1i {Conjugate = -1r+1i;
                           ImaginaryPart = -1.0;
                           Magnitude = 1.414213562;
                           Phase = -2.35619449;
                           RealPart = -1.0;
                           i = -1.0;
                           r = -1.0;}
