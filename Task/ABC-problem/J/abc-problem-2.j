   Blocks=:  ];._2 'BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM '
   ExampleWords=: <;._2 'A BaRK BOoK tREaT COmMOn SqUAD CoNfuSE '

   Blocks&abc &> ExampleWords
1 1 0 1 0 1 1
   require 'format/printf'
   '%10s  %s' printf (dquote ; 'FT' {~ Blocks&abc) &> ExampleWords
       "A"  T
    "BaRK"  T
    "BOoK"  F
   "tREaT"  T
  "COmMOn"  F
   "SqUAD"  T
 "CoNfuSE"  T
