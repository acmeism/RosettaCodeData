: e* ( x y -- x*y )
  dup 0= if nip exit then
  over 2* over 2/ recurse
  swap 1 and if + else nip then ;
