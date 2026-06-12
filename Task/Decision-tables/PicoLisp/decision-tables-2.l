(de *Conditions
   ("Printer does not print"                T   T   T   T  NIL NIL NIL NIL)
   ("A red light is flashing"               T   T  NIL NIL  T   T  NIL NIL)
   ("Printer is unrecognised"               T  NIL  T  NIL  T  NIL  T  NIL) )

(de *Actions
   ("Check the power cable"                NIL NIL  T)
   ("Check the printer-computer cable"      T  NIL  T)
   ("Ensure printer software is installed"  T  NIL  T  NIL  T  NIL  T)
   ("Check/replace ink"                     T   T  NIL NIL  T   T)
   ("Check for paper jam"                  NIL  T  NIL  T) )
