# define some appropriate OPerators #
PRIO STARTSWITH = 5, ENDSWITH = 5;
OP STARTSWITH = (STRING str, prefix)BOOL: # assuming LWB = 1 #
  IF UPB str < UPB prefix THEN FALSE ELSE str[:UPB prefix]=prefix FI;
OP ENDSWITH = (STRING str, suffix)BOOL: # assuming LWB = 1 #
  IF UPB str < UPB suffix THEN FALSE ELSE str[UPB str-UPB suffix+1:]=suffix FI;

INT loc, loc2;

print((
  "abcd" STARTSWITH "ab", # returns TRUE #
  "abcd" ENDSWITH "zn", # returns FALSE #
  string in string("bb",loc,"abab"), # returns FALSE #
  string in string("ab",loc,"abab"), # returns TRUE #
  (string in string("bb",loc,"abab")|loc|-1), # returns -1 #
  (string in string("ab",loc,"abab")|loc|-1), # returns +1 #
  (string in string("ab",loc2,"abab"[loc+1:])|loc+loc2|-1) # returns +3 #
))
