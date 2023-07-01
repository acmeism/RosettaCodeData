   NB. takes the constant beyond the repeat 9s.
   S=: cf_sqrt&163 Digits 34
   P=: pi Digits 34
   Y=: 1e_36 cf 1r8*P*S
   f=: exp&Y M.  NB. memoize
   59j40 ": 8 ^~ f Digits 34
262537412640768743.9999999999992500711164316586918409066184
   NB.                              ^
