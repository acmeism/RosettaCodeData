i=13
signal label
say 'This is never executed'
sub: Procedure Expose i
  Do i=1 To 10;
label:
    Say 'label reached, i='i
    Signal real_start
    End
  Return
 real_start:
