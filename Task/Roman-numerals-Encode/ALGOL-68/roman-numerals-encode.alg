[]CHAR roman =        "MDCLXVmdclxvi"; # UPPERCASE for thousands #
[]CHAR adjust roman = "CCXXmmccxxii";
[]INT arabic =       (1000000, 500000, 100000, 50000, 10000, 5000, 1000, 500, 100, 50, 10, 5, 1);
[]INT adjust arabic = (100000, 100000,  10000, 10000,  1000, 1000,  100, 100,  10, 10,  1, 1, 0);

PROC arabic to roman = (INT dclxvi)STRING: (
  INT in := dclxvi; # 666 #
  STRING out := "";
  FOR scale TO UPB roman WHILE in /= 0 DO
    INT multiples = in OVER arabic[scale];
    in -:= arabic[scale] * multiples;
    out +:= roman[scale] * multiples;
    IF in >= -adjust arabic[scale] + arabic[scale] THEN
      in -:= -adjust arabic[scale] + arabic[scale];
      out +:=  adjust roman[scale] +  roman[scale]
    FI
  OD;
  out
);

main:(
  []INT test = (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,30,40,50,60,69,70,
     80,90,99,100,200,300,400,500,600,666,700,800,900,1000,1009,1444,1666,1945,1997,1999,
     2000,2008,2500,3000,4000,4999,5000,6666,10000,50000,100000,500000,1000000,max int);
  FOR key TO UPB test DO
    INT val = test[key];
    print((val, " - ", arabic to roman(val), new line))
  OD
)
